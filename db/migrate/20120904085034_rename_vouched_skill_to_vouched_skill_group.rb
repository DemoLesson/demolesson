class RenameVouchedSkillToVouchedSkillGroup < ActiveRecord::Migration
  def up
    rename_table :vouched_skills, :vouched_skill_groups
  end

  def down
    rename_table :vouched_skill_groups, :vouched_skills
  end
end
