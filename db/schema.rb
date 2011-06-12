# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110604215701) do

  create_table "applications", :force => true do |t|
    t.integer  "teacher_id"
    t.integer  "job_id"
    t.text     "additional_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credentials", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "issuer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credentials_jobs", :id => false, :force => true do |t|
    t.integer  "job_id"
    t.integer  "credential_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credentials_teachers", :id => false, :force => true do |t|
    t.integer  "teacher_id"
    t.integer  "credential_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.integer  "school_id"
    t.text     "description"
    t.string   "employment_type"
    t.string   "salary"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs_subjects", :id => false, :force => true do |t|
    t.integer  "job_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "review_permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "application_id"
    t.integer  "reviewer_id"
    t.string   "rating"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.string   "location"
    t.integer  "owned_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects_teachers", :id => false, :force => true do |t|
    t.integer  "teacher_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teachers", :force => true do |t|
    t.integer  "user_id"
    t.string   "resume_file"
    t.string   "location"
    t.boolean  "special_needs"
    t.boolean  "willing_to_move"
    t.boolean  "currently_seeking"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "video_views", :force => true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", :force => true do |t|
    t.integer  "teacher_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "winks", :force => true do |t|
    t.integer  "teacher_id"
    t.integer  "job_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
