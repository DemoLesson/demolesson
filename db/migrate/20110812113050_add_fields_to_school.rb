class AddFieldsToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :website, :string
    add_column :schools, :greatschools, :string
    add_column :schools, :linkedin, :string
    add_column :schools, :facebook, :string
  end
end