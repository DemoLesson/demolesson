class ChangeVideosTable < ActiveRecord::Migration
  def self.up
    rename_column :videos, :location, :video_id
    remove_column :videos, :type
  end

  def self.down
    rename_column :videos, :video_id, :location
    add_column :videos, :type
  end
end