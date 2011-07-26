class AssetChange < ActiveRecord::Migration
  def up
    rename_column :assets, :owner_id, :teacher_id
  end

  def down
  end
end