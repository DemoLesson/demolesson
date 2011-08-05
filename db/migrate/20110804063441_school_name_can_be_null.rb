class SchoolNameCanBeNull < ActiveRecord::Migration
  def up
    change_column :schools, :name, :string, :null => true
  end

  def down
  end
end