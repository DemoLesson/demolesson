class AddDataToJobPosting < ActiveRecord::Migration
  def change
    add_column :jobs_subjects, :id, :integer
    add_column :jobs, :multiple_subject, :integer
    add_column :jobs, :bilingual, :integer
    add_column :jobs, :experience_years, :integer
    change_column :jobs, :employment_type, :integer
    add_column :jobs, :education_level, :integer
  end
end