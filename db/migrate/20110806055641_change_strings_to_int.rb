class ChangeStringsToInt < ActiveRecord::Migration
  def up
    change_column :educations, :year, :integer
  end

  def down
  end
end