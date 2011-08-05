class SchoolInfo < ActiveRecord::Migration
  def up
    add_column :schools, :district, :string
    add_column :schools, :representative_title, :string
    add_column :schools, :map_address, :string
    add_column :schools, :map_city, :string
    add_column :schools, :map_state, :integer
    add_column :schools, :map_zip, :integer
    add_column :schools, :phone, :string
    add_column :schools, :fax, :string
    add_column :schools, :school_type, :integer
    add_column :schools, :grades, :integer
    add_column :schools, :students_count, :integer
    add_column :schools, :api_ayp_scores, :string
    add_column :schools, :calendar, :integer
    add_column :schools, :mission, :string
    add_column :schools, :highlights, :string
  end

  def down
  end
end