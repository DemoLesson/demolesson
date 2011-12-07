class AddPersonalInfoSwitch < ActiveRecord::Migration
  def up
    add_column :schools, :show_personal_info, :boolean, :default => true
  end

  def down
  end
end
