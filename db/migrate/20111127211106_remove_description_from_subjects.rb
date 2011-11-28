class RemoveDescriptionFromSubjects < ActiveRecord::Migration
  def up
    remove_column :subjects, :description
  end

  def down
    add_column :subjects, :description
  end
end
