# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150502173950) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.string   "technologies"
    t.string   "summary"
    t.integer  "user_id"
    t.date     "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "slug"
  end

  add_index "events", ["slug"], name: "index_events_on_slug", unique: true, using: :btree

  create_table "newsletters", force: :cascade do |t|
    t.string   "subject",     null: false
    t.text     "body",        null: false
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "target_date"
    t.string   "slug"
  end

  add_index "newsletters", ["slug"], name: "index_newsletters_on_slug", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                               null: false
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "profile_image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_preference", default: 1
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
