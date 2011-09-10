class AddActiveToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :active, :boolean, :default => 1
  end
end
