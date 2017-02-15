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

ActiveRecord::Schema.define(version: 20170215093831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.string   "body"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "author_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["commentable_type", "author_id"], name: "index_comments_on_commentable_type_and_author_id", using: :btree
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  end

  create_table "images", force: :cascade do |t|
    t.string   "tag_names",       default: [],   null: false, array: true
    t.string   "sources",         default: [""], null: false, array: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "image"
    t.integer  "suggested_by_id"
    t.integer  "star_count",      default: 0
    t.integer  "comment_count",   default: 0
    t.index ["tag_names"], name: "index_images_on_tag_names", using: :gin
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "bio",           default: "", null: false
    t.integer  "comment_count", default: 0
    t.datetime "updated_at"
  end

  create_table "stars", force: :cascade do |t|
    t.integer "starrable_id"
    t.string  "starrable_type"
    t.integer "user_id"
    t.index ["starrable_type", "starrable_id", "user_id"], name: "index_stars_on_starrable_type_and_starrable_id_and_user_id", using: :btree
    t.index ["starrable_type", "starrable_id"], name: "index_stars_on_starrable_type_and_starrable_id", using: :btree
  end

  create_table "tags", primary_key: "name", id: :string, force: :cascade do |t|
    t.integer  "image_count", default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   default: "", null: false
    t.string   "avatar"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "images", "users", column: "suggested_by_id"
end
