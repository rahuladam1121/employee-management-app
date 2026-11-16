require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get employees_url
    assert_response :success
  end

  test "should get new" do
    get new_employee_url
    assert_response :success
  end

  test "first visit sends users to create a manager before an employee" do
    Manager.destroy_all

    get root_url

    assert_redirected_to new_manager_url
  end

  test "should show employee" do
    get employee_url(employees(:engineer))
    assert_response :success
  end
end
