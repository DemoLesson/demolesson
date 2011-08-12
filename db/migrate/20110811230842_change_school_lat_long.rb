class ChangeSchoolLatLong < ActiveRecord::Migration
  def up
    rename_column :schools, :lat, :latitude
    rename_column :schools, :lng, :longitude
    add_column :schools, :gmaps, :boolean
  end

  def down
  end
end