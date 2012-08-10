class AddPlaceholderToSkillGroup < ActiveRecord::Migration
  def change
    add_column :skill_groups, :placeholder, :string
  end
end
