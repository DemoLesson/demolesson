class AddAdditionalLinkToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :additionallinkname, :string
    add_column :schools, :additionallink, :string
  end
end
