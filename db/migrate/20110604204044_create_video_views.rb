class CreateVideoViews < ActiveRecord::Migration
  def self.up
    create_table :video_views do |t|
      t.integer :user_id, :null => false
      t.integer :video_id, :null => false
      t.integer :job_id

      t.timestamps
    end
  end

  def self.down
    drop_table :video_views
  end
end
