class ChangeMessagesColumns < ActiveRecord::Migration
  def self.up
    rename_column :messages, :from, :user_id_from
    rename_column :messages, :to, :user_id_to
    add_column :messages, :read, :boolean
  end

  def self.down
    remove_column :messages, :read
    rename_column :messages, :user_id_from, :from
    rename_column :messages, :user_id_to, :to
  end
end