class AddExternalRsvp < ActiveRecord::Migration
  def change
  	add_column :events, :rsvp_external, :string
  end
end
