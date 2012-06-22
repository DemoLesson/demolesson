class RemoveHighlightsFromSchools < ActiveRecord::Migration
  def up
    remove_column :schools, :highlights
  end

  def down
    add_column :schools, :highlights, :string
  end
end
