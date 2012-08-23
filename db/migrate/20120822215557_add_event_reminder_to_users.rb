class AddEventReminderToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :emaileventreminder, :bool
  end
end
