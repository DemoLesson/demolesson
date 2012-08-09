require 'test_helper'

class SkillClaimTest < ActiveSupport::TestCase
  test "should fail to save skill claim without user id" do
    skill_claim = SkillClaim.new(:skill_id => skills(:hs_math),
                                 :skill_group_id => skill_groups(:mathematics))
    assert !skill_claim.save, 'Able to save skill claim without user id.'
  end

  test "should fail to save skill claim without skill id" do
    skill_claim = SkillClaim.new(:user_id => users(:tbow),
                                 :skill_group_id => skill_groups(:mathematics))
    assert !skill_claim.save, 'Able to save skill claim without skill id.'
  end

  test "should fail to save skill claim without skill group id" do
    skill_claim = SkillClaim.new(:user_id => users(:tbow),
                                 :skill_id => skills(:hs_math))
    assert !skill_claim.save, 'Able to save skill claim without skill group id.'
  end
end
