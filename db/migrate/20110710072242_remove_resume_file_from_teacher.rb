class RemoveResumeFileFromTeacher < ActiveRecord::Migration
  def self.up
    remove_column :teachers, :resume_file
  end

  def self.down
    add_column :teachers, :resume_file
  end
end
