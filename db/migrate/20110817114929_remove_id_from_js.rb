class RemoveIdFromJs < ActiveRecord::Migration
  def up
    remove_column :jobs_subjects, :id
  end

  def down
  end
end
