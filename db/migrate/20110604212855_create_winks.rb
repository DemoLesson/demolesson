class CreateWinks < ActiveRecord::Migration
  def self.up
    create_table :winks do |t|
      t.integer :teacher_id
      t.integer :job_id

      t.timestamps
    end
  end

  def self.down
    drop_table :winks
  end
end
