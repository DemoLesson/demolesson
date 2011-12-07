class AddRollingDeadlineToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :rolling_deadline, :boolean, :default => false
  end
end
