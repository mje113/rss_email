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

ActiveRecord::Schema.define(version: 20130629103616) do

  create_table "feeds", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "last_fetched"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feeds", ["url"], name: "index_feeds_on_url", using: :btree

  create_table "stories", force: true do |t|
    t.string   "title"
    t.string   "permalink"
    t.text     "body"
    t.datetime "published"
    t.string   "author"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stories", ["feed_id"], name: "index_stories_on_feed_id", using: :btree
  add_index "stories", ["permalink", "feed_id"], name: "index_stories_on_permalink_and_feed_id", unique: true, using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["feed_id"], name: "index_subscriptions_on_feed_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
