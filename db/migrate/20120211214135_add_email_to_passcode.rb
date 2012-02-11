class AddEmailToPasscode < ActiveRecord::Migration
  def change
    add_column :passcodes, :sent_to, :string
  end
end
