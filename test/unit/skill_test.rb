require 'test_helper'

class SkillTest < ActiveSupport::TestCase
  test "should fail to save without name" do
    skill = Skill.new(:skill_group_id => skill_groups(:mathematics))
    assert !skill.save, 'Able to save skill without name'
  end

  test "should fail to save without skill group id" do
    skill = Skill.new(:name => 'High School Math')
    assert !skill.save, 'Able to save skill without skill group id.'
  end
end
