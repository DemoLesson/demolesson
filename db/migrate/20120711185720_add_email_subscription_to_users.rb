class AddEmailSubscriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :emailsubscription, :boolean, :default => true
  end
end
