class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :school_id
      t.text :description
      t.string :employment_type
      t.string :salary
      t.timestamp :deadline

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
