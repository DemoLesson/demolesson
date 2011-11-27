class AddBlogTitleToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :blog_title, :string
  end
end