module EmployeesHelper
  def employee_manager_options(selected_id = nil)
    Employee.alphabetical.reject { |employee| employee.id == selected_id }
  end
end
