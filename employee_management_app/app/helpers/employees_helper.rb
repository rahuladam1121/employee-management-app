module EmployeesHelper
  def employee_manager_options
    Manager.alphabetical
  end
end
