class DropVouchedSkillGroup < ActiveRecord::Migration
  def up
    drop_table :vouched_skill_groups
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
