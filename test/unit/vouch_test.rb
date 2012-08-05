require 'test_helper'

class VouchTest < ActiveSupport::TestCase
  test "should fail to save without voucher id" do
    vouch = Vouch.new(:vouchee_id => users(:tbow))
    assert !vouch.save, "Saved vouch without a voucher id"
  end

  test "should fail to save without vouchee id" do
    vouch = Vouch.new(:voucher_id => users(:tbow))
    assert !vouch.save, "Saved vouch without a vouchee id"
  end

  test "should succeed in saving vouch with both users" do
    vouch = Vouch.new(:voucher_id => users(:admin),
                      :vouchee_id => users(:tbow))
    assert vouch.save, "Couldn't save a valid vouch"
  end
end
