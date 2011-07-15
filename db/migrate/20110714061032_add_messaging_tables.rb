class AddMessagingTables < ActiveRecord::Migration
  def self.up
    remove_timestamps :messages
    add_column :messages, :from, :string
    add_column :messages, :to, :string
    add_column :messages, :subject, :string
    add_column :messages, :body, :string
    add_timestamps :messages
  end

  def self.down
    remove_timestamps :messages
  end
end