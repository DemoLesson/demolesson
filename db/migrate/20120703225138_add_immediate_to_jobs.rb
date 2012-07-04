class AddImmediateToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :immediate, :boolean, :default => false
  end
end
