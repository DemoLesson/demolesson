class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.integer :teacher_id
      t.string :location

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
