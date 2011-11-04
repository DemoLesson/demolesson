class AddAdditionalInterviewData < ActiveRecord::Migration
  def up
    add_column :interviews, :type, :integer
    add_column :interviews, :school_location, :boolean
    add_column :interviews, :location, :string
    add_column :interviews, :message, :text
  end

  def down
  end
end
