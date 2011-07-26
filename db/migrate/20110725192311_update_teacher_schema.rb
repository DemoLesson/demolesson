class UpdateTeacherSchema < ActiveRecord::Migration
  def up
    add_column :teachers, :additional_information, :string, :limit => 10000
  end

  def down
    remove_column :teachers, :additional_information
  end
end