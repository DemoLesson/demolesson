class RenameType < ActiveRecord::Migration
  def self.up
    rename_column :alphas, :type, :userType
  end

  def self.down
    rename_column :alphas, :userType, :type
  end
end