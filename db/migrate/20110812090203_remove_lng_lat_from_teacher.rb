class RemoveLngLatFromTeacher < ActiveRecord::Migration
  def up
    remove_column :teachers, :lng
    remove_column :teachers, :lat
  end

  def down
  end
end
