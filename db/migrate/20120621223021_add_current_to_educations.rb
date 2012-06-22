class AddCurrentToEducations < ActiveRecord::Migration
  def change
    add_column :educations, :current, :boolean
  end
end
