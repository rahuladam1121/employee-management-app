class CreateManagersAndDepartments < ActiveRecord::Migration[7.1]
  def up
    create_table :managers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone
      t.timestamps
    end
    add_index :managers, :email, unique: true

    create_table :departments do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :departments, :name, unique: true

    if foreign_key_exists?(:employees, :employees, column: :manager_id)
      remove_foreign_key :employees, :employees, column: :manager_id
    end
    rename_column :employees, :manager_id, :legacy_manager_id
    add_column :employees, :manager_id, :integer
    add_column :employees, :department_id, :integer

    connection.select_all("SELECT DISTINCT department FROM employees").each do |row|
      department_id = insert_record(:departments, name: row["department"])
      connection.execute(
        "UPDATE employees SET department_id = #{department_id} WHERE department = #{connection.quote(row['department'])}"
      )
    end

    connection.select_all(<<~SQL).each do |row|
      SELECT DISTINCT employees.id, employees.first_name, employees.last_name, employees.email, employees.phone
      FROM employees
      INNER JOIN employees AS reports ON reports.legacy_manager_id = employees.id
    SQL
      manager_id = insert_record(
        :managers,
        first_name: row["first_name"],
        last_name: row["last_name"],
        email: row["email"],
        phone: row["phone"]
      )
      connection.execute("UPDATE employees SET manager_id = #{manager_id} WHERE legacy_manager_id = #{row['id']}")
    end

    remove_column :employees, :department
    remove_column :employees, :legacy_manager_id
    add_index :employees, :manager_id
    add_index :employees, :department_id
    add_foreign_key :employees, :managers, on_delete: :nullify
    add_foreign_key :employees, :departments
  end

  def down
    remove_foreign_key :employees, :managers
    remove_foreign_key :employees, :departments
    remove_index :employees, :manager_id
    remove_index :employees, :department_id
    add_column :employees, :department, :string
    add_column :employees, :legacy_manager_id, :integer

    connection.select_all("SELECT id, name FROM departments").each do |row|
      connection.execute(
        "UPDATE employees SET department = #{connection.quote(row['name'])} WHERE department_id = #{row['id']}"
      )
    end
    connection.select_all("SELECT id, email FROM managers").each do |row|
      employee_id = connection.select_value("SELECT id FROM employees WHERE email = #{connection.quote(row['email'])}")
      next unless employee_id

      connection.execute("UPDATE employees SET legacy_manager_id = #{employee_id} WHERE manager_id = #{row['id']}")
    end

    remove_column :employees, :manager_id
    remove_column :employees, :department_id
    rename_column :employees, :legacy_manager_id, :manager_id
    add_foreign_key :employees, :employees, column: :manager_id, on_delete: :nullify
    drop_table :departments
    drop_table :managers
  end

  private

  def insert_record(table, attributes)
    now = connection.quote(Time.current)
    columns = attributes.keys + %i[created_at updated_at]
    values = attributes.values.map { |value| connection.quote(value) } + [now, now]
    connection.execute(
      "INSERT INTO #{table} (#{columns.join(', ')}) VALUES (#{values.join(', ')})"
    )
    connection.select_value("SELECT last_insert_rowid()").to_i
  end
end
