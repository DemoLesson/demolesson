class AddFirstAndLastNameToUsers < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    User.all.each do |user|
      name_parts = user.name.split(' ')
      last_name  = name_parts.last
      first_name = name_parts - [last_name]
      user.first_name = first_name.join(' ')
      user.last_name = last_name
      user.save!(:validate => false)
    end
  end

  def down
    remove_column :users, :first_name
    remove_column :users, :last_name
  end
end
