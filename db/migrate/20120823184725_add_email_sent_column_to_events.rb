class AddEmailSentColumnToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :email_sent, :bool
  	add_column :users, :emaileventapproved, :bool
  end
end
