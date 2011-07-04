class RemoveTimestamp < ActiveRecord::Migration
  def self.up
    remove_column :credentials_jobs, :created_at 
    remove_column :credentials_jobs, :updated_at
    remove_column :jobs_subjects, :created_at
    remove_column :jobs_subjects, :updated_at
    remove_column :review_permissions, :created_at
    remove_column :review_permissions, :updated_at
  end

  def self.down
  end
end
