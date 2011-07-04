class ChangeType < ActiveRecord::Migration
  def self.up
    rename_column :credentials, :type, :credentialType
  end

  def self.down
    rename_column :credentials, :credentialType, :type
  end
end