class AddPhoneNumber < ActiveRecord::Migration
  def self.up
    add_column :teachers, :phone, :string
  end

  def self.down
    remove_column :teachers, :phone
  end
end
