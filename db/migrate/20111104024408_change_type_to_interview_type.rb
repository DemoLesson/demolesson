class ChangeTypeToInterviewType < ActiveRecord::Migration
  def up
    rename_column :interviews, :type, :interview_type
  end

  def down
  end
end