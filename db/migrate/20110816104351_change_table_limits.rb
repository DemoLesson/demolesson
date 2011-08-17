class ChangeTableLimits < ActiveRecord::Migration
  def up
    change_column :schools, :mission, :string, :limit => 1000
    change_column :schools, :highlights, :string, :limit => 1000
  end

  def down
  end
end