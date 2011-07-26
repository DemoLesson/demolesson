class ChangesNames < ActiveRecord::Migration
  def up
    rename_table :experience, :experiences
    rename_table :education, :educations
  end

  def down
  end
end