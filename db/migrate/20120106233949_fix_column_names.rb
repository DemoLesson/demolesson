class FixColumnNames < ActiveRecord::Migration
  def up  
    rename_column :schools, :avatar_file_name, :picture_file_name
    rename_column :schools, :avatar_content_type, :picture_content_type
    rename_column :schools, :avatar_file_size, :picture_file_size
    rename_column :schools, :avatar_updated_at, :picture_updated_at
  end

  def down
  end
end