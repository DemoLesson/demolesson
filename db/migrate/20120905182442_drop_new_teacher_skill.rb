class DropNewTeacherSkill < ActiveRecord::Migration
  def up
    drop_table :new_teacher_skills
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
