class AddTempImageToUser < ActiveRecord::Migration
  def change
    add_column :users, :original_name, :string
    add_column :users, :temp_img_name, :string
  end
end
