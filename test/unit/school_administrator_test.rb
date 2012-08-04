require 'test_helper'

class SchoolAdministratorTest < ActiveSupport::TestCase
  test "should fail to save without user" do
    sa = SchoolAdministrator.new(:school => schools(:denim_green))
    assert !sa.save, "Saved school administrator without a user"
  end

  test "should fail to save without school" do
    sa = SchoolAdministrator.new(:user => users(:one))
    assert !sa.save, "Saved school administrator without a school"
  end
end
