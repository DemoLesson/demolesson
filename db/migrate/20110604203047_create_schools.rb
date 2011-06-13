class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.string :name
      t.string :location
      t.text :description
      t.integer :owned_by
      t.float :lng
      t.float :lat
      
      t.timestamps
    end
  end

  def self.down
    drop_table :schools
  end
end
