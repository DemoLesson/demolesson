class AddLinkedinToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :linkedin, :string
  end
end
