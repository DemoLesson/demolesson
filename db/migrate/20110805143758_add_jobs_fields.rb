class AddJobsFields < ActiveRecord::Migration
  def up
    add_column :jobs, :title, :string
  end

  def down
    remove_column :jobs, :title
  end
end
