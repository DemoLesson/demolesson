class AddGuestCodeToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :guest_code, :string
  end
end
