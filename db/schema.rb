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

ActiveRecord::Schema.define(version: 20170203075520) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: :cascade do |t|
    t.integer  "upvotes"
    t.integer  "downvotes"
    t.string   "tag_names",  default: [],   null: false, array: true
    t.string   "sources",    default: [""], null: false, array: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "image"
    t.index ["tag_names"], name: "index_images_on_tag_names", using: :gin
  end

  create_table "tags", primary_key: "name", id: :string, force: :cascade do |t|
    t.integer  "image_count", default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
