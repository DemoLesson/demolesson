class CreatePins < ActiveRecord::Migration
  def self.up
    create_table :pins do |t|
      t.integer :user_id
      t.integer :teacher_id
      t.integer :job_id
      t.timestamps
    end
  end

  def self.down
    drop_table :pins
  end
end
