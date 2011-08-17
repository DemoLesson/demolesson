class ChangeNumberToString < ActiveRecord::Migration
  def up
    change_column :schools, :students_count, :string, :limit => 25
  end

  def down
  end
end
