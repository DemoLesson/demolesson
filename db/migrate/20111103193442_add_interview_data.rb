class AddInterviewData < ActiveRecord::Migration
  def up
    add_column :interviews, :teacher_id, :integer
    add_column :interviews, :job_id, :integer
    add_column :interviews, :date, :timestamp
    add_column :interviews, :date_alternate, :timestamp
    add_column :interviews, :date_alternate_second, :timestamp
    add_column :interviews, :selected, :integer, :default => 0
  end

  def down
  end
end