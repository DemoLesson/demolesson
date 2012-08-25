class RemoveFieldsFromConnectionInvite < ActiveRecord::Migration
  def up
    remove_column :connection_invites, :first_name
    remove_column :connection_invites, :last_name
  end

  def down
    add_column :connection_invites, :last_name, :string
    add_column :connection_invites, :first_name, :string
  end
end
