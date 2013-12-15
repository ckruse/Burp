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

ActiveRecord::Schema.define(version: 5) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: true do |t|
    t.string   "username",                            null: false
    t.string   "name",                                null: false
    t.string   "email",                               null: false
    t.string   "url"
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authors", ["email"], name: "index_authors_on_email", unique: true, using: :btree
  add_index "authors", ["reset_password_token"], name: "index_authors_on_reset_password_token", unique: true, using: :btree
  add_index "authors", ["username"], name: "index_authors_on_username", unique: true, using: :btree

  create_table "blogs", force: true do |t|
    t.string   "name",                     null: false
    t.string   "description",              null: false
    t.string   "keywords",                 null: false
    t.string   "url",                      null: false
    t.string   "image_url",                null: false
    t.string   "lang",                     null: false
    t.string   "host",                     null: false
    t.json     "attrs",       default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id",                null: false
  end

  add_index "blogs", ["author_id"], name: "index_blogs_on_author_id", using: :btree
  add_index "blogs", ["host"], name: "index_blogs_on_host", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.integer  "post_id",                 null: false
    t.boolean  "visible",                 null: false
    t.string   "author",                  null: false
    t.string   "email"
    t.string   "url"
    t.json     "attrs",      default: {}, null: false
    t.text     "content",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "posts", force: true do |t|
    t.string   "slug",                          null: false
    t.string   "guid",                          null: false
    t.boolean  "visible",                       null: false
    t.integer  "blog_id",                       null: false
    t.integer  "author_id",                     null: false
    t.string   "subject",                       null: false
    t.text     "excerpt"
    t.text     "content",                       null: false
    t.string   "format",       default: "html", null: false
    t.json     "attrs",        default: {},     null: false
    t.datetime "published_at",                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["blog_id"], name: "index_posts_on_blog_id", using: :btree
  add_index "posts", ["guid"], name: "index_posts_on_guid", unique: true, using: :btree
  add_index "posts", ["slug"], name: "index_posts_on_slug", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.integer "post_id",  null: false
    t.string  "tag_name", null: false
  end

  add_index "tags", ["post_id"], name: "index_tags_on_post_id", using: :btree

end
