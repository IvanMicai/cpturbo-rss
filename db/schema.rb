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

ActiveRecord::Schema.define(version: 20160222135249) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.integer  "post_id"
    t.date     "published_at"
    t.string   "author_name"
    t.integer  "author_id"
    t.text     "description"
    t.string   "topic_category_0"
    t.string   "topic_category_1"
    t.string   "topic_category_2"
    t.string   "topic_category_3"
    t.string   "topic_category_4"
    t.string   "topic_category_5"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end