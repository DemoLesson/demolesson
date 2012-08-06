require 'test_helper'

class SkillGroupTest < ActiveSupport::TestCase
  test "should fail to save without badge url" do
    skill_group = SkillGroup.new(:name => 'Mathematics')
    assert !skill_group.save, 'Able to save skill group without badge url.'
  end

  test "should fail to save without name" do
    skill_group = SkillGroup.new(:badge_url => 'http://s3.org/mathematics.jpg')
    assert !skill_group.save, 'Able to save skill group without name.'
  end
end
