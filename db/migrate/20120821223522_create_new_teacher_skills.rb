class CreateNewTeacherSkills < ActiveRecord::Migration
  def change
    create_table :new_teacher_skills do |t|
      t.integer :vouch_id
      t.integer :skill_group_id

      t.timestamps
    end
  end
end
