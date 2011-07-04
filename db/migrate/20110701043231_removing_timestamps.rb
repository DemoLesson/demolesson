class RemovingTimestamps < ActiveRecord::Migration
  def self.up
    remove_column :credentials_teachers, :created_at
    remove_column :credentials_teachers, :updated_at
    remove_column :subjects_teachers, :created_at
    remove_column :subjects_teachers, :updated_at
  end

  def self.down
  end
end
