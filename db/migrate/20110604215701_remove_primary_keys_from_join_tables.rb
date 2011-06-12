class RemovePrimaryKeysFromJoinTables < ActiveRecord::Migration
  def self.up
	remove_column :jobs_subjects, :id
	remove_column :subjects_teachers, :id
	remove_column :credentials_jobs, :id
	remove_column :credentials_teachers, :id
  end

  def self.down
  end
end
