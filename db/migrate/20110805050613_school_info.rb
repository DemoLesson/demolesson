class SchoolInfo < ActiveRecord::Migration
  def up
    add_column :schools, :district, :string
    add_column :representative_title, :string
  end

  def down
  end
end