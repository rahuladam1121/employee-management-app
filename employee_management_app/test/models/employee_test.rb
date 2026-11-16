require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test "valid employee fixture belongs to its manager" do
    employee = employees(:engineer)
    assert_equal employees(:manager), employee.manager
  end

  test "manager can have multiple subordinates" do
    assert_includes employees(:manager).subordinates, employees(:engineer)
  end

  test "email is normalized to lowercase" do
    employee = Employee.new(employee_number: "EMP-NEW", first_name: "Test", last_name: "User",
      email: " TEST@EXAMPLE.COM ", department: "IT", job_title: "Developer", joining_date: Date.today)
    assert employee.valid?
    assert_equal "test@example.com", employee.email
  end
end
