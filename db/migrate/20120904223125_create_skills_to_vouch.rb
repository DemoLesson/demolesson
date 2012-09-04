class CreateSkillsToVouch < ActiveRecord::Migration
  def change
    create_table :skills_to_vouch do |t|
      t.integer :skill_id
      t.integer :vouch_id

      t.timestamps
    end
  end
end
