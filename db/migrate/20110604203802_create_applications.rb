class CreateApplications < ActiveRecord::Migration
  def self.up
    create_table :applications do |t|
      t.integer :teacher_id, :null => false
      t.integer :job_id, :null => false
      t.text :additional_notes
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :applications
  end
end
