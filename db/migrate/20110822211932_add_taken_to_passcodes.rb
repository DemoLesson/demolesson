class AddTakenToPasscodes < ActiveRecord::Migration
  def change
    add_column :passcodes, :given_out, :boolean
  end
end
