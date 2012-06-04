class AddSnippetToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :is_snippet, :boolean, :default => false, :null => false
  end
end
