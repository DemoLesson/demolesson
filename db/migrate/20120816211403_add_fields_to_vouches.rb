class AddFieldsToVouches < ActiveRecord::Migration
  def change
    add_column :vouches, :first_name, :string
    add_column :vouches, :last_name, :string
    add_column :vouches, :email, :string
    add_column :vouches, :company, :string
    add_column :vouches, :title, :string
    add_column :vouches, :pending, :boolean, :default => true
    add_column :vouches, :url, :string
  end
end
