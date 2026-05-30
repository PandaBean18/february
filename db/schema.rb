# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_30_190154) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "post_category", ["Production Meltdown", "Git Tangle", "Tutorial hell", "meeting mishap", "burnout", "client chaos", "startup burial", "imposter syndrome", "General mess"]

  create_table "media", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "cloudinary_public_id", null: false
    t.datetime "created_at", null: false
    t.string "media_type", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_stickers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "post_id", null: false
    t.uuid "sticker_id", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_stickers_on_post_id"
    t.index ["sticker_id"], name: "index_post_stickers_on_sticker_id"
  end

  create_table "posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.enum "category", default: "General mess", null: false, enum_type: "post_category"
    t.datetime "created_at", null: false
    t.text "story"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "reactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "post_id", null: false
    t.string "reaction_type"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["post_id"], name: "index_reactions_on_post_id"
    t.index ["user_id"], name: "index_reactions_on_user_id"
  end

  create_table "stickers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "medium_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["medium_id"], name: "index_stickers_on_medium_id"
    t.index ["name"], name: "index_stickers_on_name", unique: true
    t.index ["user_id"], name: "index_stickers_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "updated_at", null: false
    t.string "username"
  end

  add_foreign_key "post_stickers", "posts"
  add_foreign_key "post_stickers", "stickers"
  add_foreign_key "posts", "users"
  add_foreign_key "reactions", "posts"
  add_foreign_key "reactions", "users"
  add_foreign_key "stickers", "media"
  add_foreign_key "stickers", "users"
end
