class AddJobidToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :job_id, :integer
  end
end
