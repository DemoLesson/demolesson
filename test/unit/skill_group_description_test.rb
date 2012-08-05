require 'test_helper'

class SkillGroupDescriptionTest < ActiveSupport::TestCase
  test "should fail to save without description" do
    sgd = SkillGroupDescription.new(:user_id => users(:tbow),
                                    :skill_group_id => skill_groups(:mathematics))
    assert !sgd.save, "Skill group description saved without a description."
  end

  test "should fail to save without user id" do
    sgd = SkillGroupDescription.new(:description => "Really good at maths",
                                    :skill_group_id => skill_groups(:mathematics))
    assert !sgd.save, "Skill group description saved without a user id."
  end

  test "should fail to save without skill group id" do
    sgd = SkillGroupDescription.new(:description => "Really good at maths",
                                    :user_id => users(:tbow))
    assert !sgd.save, "Skill group description saved without skill group id."
  end
end
