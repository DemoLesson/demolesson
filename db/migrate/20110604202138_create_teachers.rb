class CreateTeachers < ActiveRecord::Migration
  def self.up
    create_table :teachers do |t|
      t.integer :user_id, :null => false
      t.string :resume_file
      t.string :location
      t.float :lng
      t.float :lat
      t.boolean :special_needs
      t.boolean :willing_to_move, :default => false
      t.boolean :currently_seeking, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :teachers
  end
end
