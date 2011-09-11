class AddViewedToApplication < ActiveRecord::Migration
  def change
    add_column :applications, :viewed, :boolean
    change_column :applications, :status, :integer
  end
end