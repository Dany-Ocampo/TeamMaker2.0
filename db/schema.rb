# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_11_14_224142) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "test_id", null: false
    t.integer "number"
    t.integer "answer"
    t.integer "element_kind"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["test_id"], name: "index_answers_on_test_id"
  end

  create_table "course_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "courses", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.bigint "course_type_id", null: false
    t.string "code"
    t.integer "year"
    t.integer "semester"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_type_id"], name: "index_courses_on_course_type_id"
    t.index ["subject_id"], name: "index_courses_on_subject_id"
  end

  create_table "eneatypes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "number"
    t.integer "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_eneatypes_on_user_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.bigint "institution_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["institution_id"], name: "index_programs_on_institution_id"
  end

  create_table "programs_users", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.bigint "user_id", null: false
    t.index ["program_id"], name: "index_programs_users_on_program_id"
    t.index ["user_id"], name: "index_programs_users_on_user_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "kind"
    t.boolean "status"
    t.boolean "answered"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "course_id"
    t.index ["user_id"], name: "index_tests_on_user_id"
  end

  create_table "user_courses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.integer "group_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_user_courses_on_course_id"
    t.index ["user_id"], name: "index_user_courses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "name"
    t.string "surname"
    t.integer "sex"
    t.integer "age"
    t.integer "test_count", default: 0, null: false
    t.integer "rol", default: 3, null: false
    t.boolean "status", default: true, null: false
    t.boolean "accept_model"
    t.boolean "study_group"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answers", "tests"
  add_foreign_key "courses", "course_types"
  add_foreign_key "courses", "subjects"
  add_foreign_key "eneatypes", "users"
  add_foreign_key "programs", "institutions"
  add_foreign_key "programs_users", "programs"
  add_foreign_key "programs_users", "users"
  add_foreign_key "tests", "users"
  add_foreign_key "user_courses", "courses"
  add_foreign_key "user_courses", "users"
end
