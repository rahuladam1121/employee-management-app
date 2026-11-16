require "test_helper"

class ManagerTest < ActiveSupport::TestCase
  test "normalizes email and validates phone format" do
    manager = Manager.new(
      first_name: "Test",
      last_name: "Manager",
      email: " TEST.MANAGER@EXAMPLE.COM ",
      phone: "+1 (415) 555-0132"
    )

    assert manager.valid?
    assert_equal "test.manager@example.com", manager.email

    manager.phone = "not-a-phone"
    assert_not manager.valid?
    assert_includes manager.errors[:phone], "must be a valid phone number"
  end
end
