class ChangeFieldTypes < ActiveRecord::Migration
  def up
    #change TEXT to VARCHAR limit 255
    change_column :assets, :description, :string
  end

  def down
  end
end