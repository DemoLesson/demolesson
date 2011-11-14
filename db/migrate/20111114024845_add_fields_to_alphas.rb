class AddFieldsToAlphas < ActiveRecord::Migration
  def change
    add_column :alphas, :name, :string
    add_column :alphas, :beta, :boolean
  end
end