class AddTeacherFields < ActiveRecord::Migration
  def self.up
    remove_column :teachers, :phone
    add_column :teachers, :phone, :string
    add_column :teachers, :position, :string
    add_column :teachers, :school, :string
    add_column :teachers, :location, :string
    add_column :teachers, :seeking_subject, :string
    add_column :teachers, :seeking_grade, :string
    add_column :teachers, :seeking_location, :string
  end

  def self.down
    remove_column :teachers, :phone
    remove_column :teachers, :position
    remove_column :teachers, :school
    remove_column :teachers, :location
    remove_column :teachers, :seeking_subject
    remove_column :teachers, :seeking_grade
    remove_column :teachers, :seeking_location
  end
end
