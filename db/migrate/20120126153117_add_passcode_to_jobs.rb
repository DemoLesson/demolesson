class AddPasscodeToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :passcode, :string
  end
end
