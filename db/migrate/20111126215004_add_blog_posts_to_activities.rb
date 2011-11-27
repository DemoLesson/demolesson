class AddBlogPostsToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :blog_url, :string
  end
end