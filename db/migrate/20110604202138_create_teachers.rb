class CreateTeachers < ActiveRecord::Migration
  def self.up
    create_table :teachers do |t|
      t.integer :user_id
      t.string :resume_file
      t.string :location
      t.boolean :special_needs
      t.boolean :willing_to_move
      t.boolean :currently_seeking

      t.timestamps
    end
  end

  def self.down
    drop_table :teachers
  end
end
