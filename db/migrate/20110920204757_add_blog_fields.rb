class AddBlogFields < ActiveRecord::Migration
  def up
    add_column :blog_entries, :title, :string, :limit => 255
    add_column :blog_entries, :content, :text
  end

  def down
  end
end
