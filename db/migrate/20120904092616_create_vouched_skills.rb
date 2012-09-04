class CreateVouchedSkills < ActiveRecord::Migration
  def change
    create_table :vouched_skills do |t|
      t.integer :vouch_id
      t.integer :skill_id
      t.integer :user_id

      t.timestamps
    end
  end
end
