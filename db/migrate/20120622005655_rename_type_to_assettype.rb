class RenameTypeToAssettype < ActiveRecord::Migration
  def up
    rename_column :assets, :type, :assetType
  end

  def down
    rename_column :assets, :assetType, :type 
  end
end
