class AddEmbed < ActiveRecord::Migration
  def self.up
	add_column :videos, :embedcode, :string
  end

  def self.down
	remove_column :videos, :embedcode
  end
end
