class AddForEducatorToVouch < ActiveRecord::Migration
  def change
    add_column :vouches, :for_new_educator, :boolean, :default => false
  end
end
