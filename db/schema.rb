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

ActiveRecord::Schema.define(version: 20170307223144) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "food_choices", force: :cascade do |t|
    t.integer  "person_id",  null: false
    t.integer  "food_id",    null: false
    t.integer  "sitting",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_food_choices_on_food_id", using: :btree
    t.index ["person_id"], name: "index_food_choices_on_person_id", using: :btree
  end

  create_table "foods", force: :cascade do |t|
    t.string   "title",      null: false
    t.integer  "sitting",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sitting"], name: "index_foods_on_sitting", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "full_name",            null: false
    t.boolean  "attending_breakfast"
    t.boolean  "attending_reception"
    t.integer  "rsvp_code_id",         null: false
    t.string   "dietary_requirements"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["rsvp_code_id"], name: "index_people_on_rsvp_code_id", using: :btree
  end

  create_table "rsvp_codes", force: :cascade do |t|
    t.string   "secret",                     null: false
    t.boolean  "breakfast",                  null: false
    t.boolean  "reception",                  null: false
    t.boolean  "responded",  default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["secret"], name: "index_rsvp_codes_on_secret", using: :btree
  end

  add_foreign_key "food_choices", "foods", name: "food_choices_food_id_fk"
  add_foreign_key "food_choices", "people", name: "food_choices_person_id_fk"
  add_foreign_key "people", "rsvp_codes", name: "people_rsvp_code_id_fk"
end
