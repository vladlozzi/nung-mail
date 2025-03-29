# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_05_105620) do
  create_table "applications", force: :cascade do |t|
    t.integer "edebo_person_card", null: false
    t.string "fullname_birthdate", null: false
    t.string "phone_number", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emails", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_emails_on_email", unique: true
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "first_name_lat", null: false
    t.string "last_name_lat", null: false
    t.integer "graduate_at", null: false
    t.string "mobile_number", null: false
    t.string "academic_group", null: false
    t.string "faculty_name", null: false
    t.integer "edebo_study_card", null: false
    t.integer "edebo_person_card", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["edebo_study_card"], name: "index_students_on_edebo_study_card", unique: true
  end
end
