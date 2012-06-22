class AddApplicationidToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :application_id, :integer
    add_column :assets, :type, :integer, :default => 0
  end
end
