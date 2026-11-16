require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test "valid employee fixture belongs to its manager" do
    employee = employees(:engineer)
    assert_equal managers(:manager), employee.manager
    assert_equal departments(:engineering), employee.department
  end

  test "manager can have multiple employees" do
    assert_includes managers(:manager).employees, employees(:engineer)
  end

  test "email is normalized to lowercase" do
    employee = Employee.new(employee_number: "EMP-NEW", first_name: "Test", last_name: "User",
      email: " TEST@EXAMPLE.COM ", department: departments(:engineering), job_title: "Developer", joining_date: Date.today)
    assert employee.valid?
    assert_equal "test@example.com", employee.email
  end

  test "rejects malformed email and phone values" do
    employee = employees(:engineer).dup
    employee.employee_number = "EMP-INVALID"
    employee.email = "not-an-email"
    employee.phone = "call me maybe"

    assert_not employee.valid?
    assert_includes employee.errors[:email], "is invalid"
    assert_includes employee.errors[:phone], "must be a valid phone number"
  end

  test "accepts a phone number with international punctuation" do
    employee = employees(:engineer).dup
    employee.employee_number = "EMP-PHONE"
    employee.phone = "+1 (415) 555-0132"

    assert employee.valid?
  end
end
