class RemoveSpecialNeedsFromTeacher < ActiveRecord::Migration
  def up
    remove_column :teachers, :special_needs
  end

  def down
    add_column :teachers, :special_needs, :boolean
  end
end
