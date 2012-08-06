class CreateSkillGroupDescriptions < ActiveRecord::Migration
  def change
    create_table :skill_group_descriptions do |t|
      t.string :description
      t.integer :user_id
      t.integer :skill_group_id

      t.timestamps
    end
  end
end
