class AddUsername < ActiveRecord::Migration
  def self.up
    add_column :teachers, :url, :string
  end

  def self.down
    remove_column :teachers, :url
  end
end
