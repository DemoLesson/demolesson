class AddVideoEmbedToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :video_embed_url, :string
    add_column :teachers, :video_embed_html, :text
  end
end
