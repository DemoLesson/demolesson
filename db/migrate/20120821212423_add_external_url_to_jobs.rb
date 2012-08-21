class AddExternalUrlToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :external_url, :string
  end
end
