class AddExperienceAndEducation < ActiveRecord::Migration
  def up
    create_table "experience", :force => true do |t|
      t.string   "company"
      t.string   "position"
      t.string   "description", :limit => 10000
      t.integer  "startMonth"
      t.integer  "startYear"
      t.integer  "endMonth"
      t.integer  "endYear"
      t.boolean  "current"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "teacher_id"
    end
    create_table "education", :force => true do |t|
      t.string   "school"
      t.string   "degree"
      t.string   "concentrations"
      t.string   "year"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "teacher_id"
    end
  end

  def down
    drop_table :experience
    drop_table :education
  end
end