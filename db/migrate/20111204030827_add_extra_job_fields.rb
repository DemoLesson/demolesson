class AddExtraJobFields < ActiveRecord::Migration
  def up
    add_column :jobs, :grade_level, :integer
    add_column :jobs, :credential_type, :integer
    add_column :jobs, :years_of_experience, :integer
    
  end

  def down
  end
end
