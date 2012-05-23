class AddSharedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_shared, :boolean, :default => false, :null => false
    add_column :users, :is_limited, :boolean, :default => false, :null => false
  end
end
