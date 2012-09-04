class CreateReturnedSkills < ActiveRecord::Migration
  def change
    create_table :returned_skills do |t|
      t.integer :vouch_id
      t.integer :skill_id

      t.timestamps
    end
  end
end
