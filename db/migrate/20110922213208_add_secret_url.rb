class AddSecretUrl < ActiveRecord::Migration
  def up
    add_column :videos, :secret_url, :string
  end

  def down
    remove_column :videos, :secret_url
  end
end
