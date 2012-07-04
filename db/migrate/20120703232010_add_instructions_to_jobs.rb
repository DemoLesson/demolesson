class AddInstructionsToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :instructions, :text
  end
end
