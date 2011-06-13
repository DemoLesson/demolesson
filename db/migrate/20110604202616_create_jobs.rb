class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :school_id, :null => false
      t.text :description
      t.string :employment_type
      t.string :salary
      t.boolean :special_needs
      t.timestamp :deadline

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
