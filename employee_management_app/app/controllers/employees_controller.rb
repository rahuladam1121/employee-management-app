class EmployeesController < ApplicationController
  before_action :require_initial_manager, only: %i[new create]
  before_action :set_employee, only: %i[show edit update destroy]

  def index
    if Manager.none?
      redirect_to new_manager_path, notice: "Create a manager before adding employees."
      return
    end

    @employees = Employee.includes(:manager, :department).alphabetical
  end

  def show
  end

  def new
    if Department.none?
      redirect_to new_department_path, notice: "Create a department before adding employees."
      return
    end

    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to @employee, notice: "Employee was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to @employee, notice: "Employee was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path, notice: "Employee was deleted. Any direct reports are now unassigned.", status: :see_other
  end

  private

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def require_initial_manager
    return unless Manager.none?

    redirect_to new_manager_path, notice: "Create a manager before adding employees."
  end

  def employee_params
    params.require(:employee).permit(
      :employee_number, :first_name, :last_name, :email, :phone,
      :department_id, :job_title, :salary, :joining_date, :manager_id
    )
  end
end
