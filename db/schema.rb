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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170326173044) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"

  create_table "food_choices", id: :serial, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "food_id", null: false
    t.integer "sitting", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_food_choices_on_food_id"
    t.index ["person_id"], name: "index_food_choices_on_person_id"
  end

  create_table "foods", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.integer "sitting", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "child", default: false
    t.integer "food_choices_count", default: 0
    t.index ["sitting"], name: "index_foods_on_sitting"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "full_name", null: false
    t.boolean "attending_ceremony"
    t.boolean "attending_reception"
    t.integer "rsvp_code_id"
    t.string "dietary_requirements"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "child", default: false
    t.index ["rsvp_code_id"], name: "index_people_on_rsvp_code_id"
  end

  create_table "rsvp_codes", id: :serial, force: :cascade do |t|
    t.citext "secret", null: false
    t.boolean "ceremony", null: false
    t.boolean "reception", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "responded", default: false
    t.index ["secret"], name: "index_rsvp_codes_on_secret"
  end

  add_foreign_key "food_choices", "foods", name: "food_choices_food_id_fk"
  add_foreign_key "food_choices", "people", name: "food_choices_person_id_fk"
  add_foreign_key "people", "rsvp_codes", name: "people_rsvp_code_id_fk"
end
