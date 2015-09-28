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

ActiveRecord::Schema.define(version: 20150927135711) do

  create_table "banners", force: :cascade do |t|
    t.string   "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "group_token"
  end

  create_table "comments", force: :cascade do |t|
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "proposal_id"
    t.text     "body"
    t.string   "token"
    t.integer  "comment_id"
    t.text     "location"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "unique_token"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "location"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "expires_at"
  end

  create_table "hashtags", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "proposal_id"
    t.integer  "comment_id"
    t.integer  "group_id"
    t.string   "tag"
    t.integer  "index"
    t.string   "token"
  end

  create_table "manifestos", force: :cascade do |t|
    t.text     "title"
    t.text     "body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.boolean  "ratified"
    t.string   "group_token"
  end

  create_table "meetups", force: :cascade do |t|
    t.text     "title"
    t.text     "body"
    t.date     "date"
    t.text     "location"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "group_id"
    t.text     "body"
    t.binary   "salt"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "token"
    t.string   "image"
    t.string   "group_token"
  end

  create_table "notes", force: :cascade do |t|
    t.text     "message"
    t.string   "action"
    t.integer  "item_id"
    t.string   "item_token"
    t.string   "sender_token"
    t.string   "receiver_token"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.boolean  "seen"
  end

  create_table "proposals", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "body"
    t.text     "title"
    t.string   "token"
    t.boolean  "ratified"
    t.string   "action"
    t.integer  "group_id"
    t.integer  "ratification_point"
    t.boolean  "requires_revision"
    t.string   "image"
    t.text     "location"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "manifesto_id"
    t.string   "misc_data"
    t.integer  "proposal_id"
    t.string   "revised_action"
    t.string   "unique_token"
    t.string   "group_token"
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "proposal_id"
    t.string   "flip_state"
    t.integer  "comment_id"
    t.string   "token"
  end

end
