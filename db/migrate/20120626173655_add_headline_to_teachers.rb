class AddHeadlineToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :headline, :string, :limit => 140
  end
end
