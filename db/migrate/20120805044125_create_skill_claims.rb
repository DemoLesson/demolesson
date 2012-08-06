class CreateSkillClaims < ActiveRecord::Migration
  def change
    create_table :skill_claims do |t|
      t.integer :user_id
      t.integer :skill_id
      t.integer :skill_group_id

      t.timestamps
    end
  end
end
