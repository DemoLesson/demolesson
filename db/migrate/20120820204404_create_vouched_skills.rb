class CreateVouchedSkills < ActiveRecord::Migration
  def change
    create_table :vouched_skills do |t|
      t.integer :skill_group_id
      t.integer :user_id
      t.integer :vouch_id

      t.timestamps
    end
  end
end
