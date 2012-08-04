require 'test_helper'

class SchoolAdministratorTest < ActiveSupport::TestCase
  test "should fail to save without user" do
    sa = SchoolAdministrator.new(:school => schools(:denim_green).find)
    assert !sa.save, "Saved school administrator without a user"
  end
end
