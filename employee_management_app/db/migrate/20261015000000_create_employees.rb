class CreateEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :employees do |t|
      t.string :employee_number, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :department, null: false
      t.string :job_title, null: false
      t.decimal :salary, precision: 12, scale: 2
      t.date :joining_date, null: false
      t.references :manager, foreign_key: { to_table: :employees, on_delete: :nullify }
      t.timestamps
    end

    add_index :employees, :employee_number, unique: true
    add_index :employees, :email, unique: true
  end
end
