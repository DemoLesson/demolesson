class AddStartYearToEducations < ActiveRecord::Migration
  def change
    add_column :educations, :start_year, :integer
  end
end
