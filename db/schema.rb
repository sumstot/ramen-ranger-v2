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

ActiveRecord::Schema[7.1].define(version: 2024_04_27_033349) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "comments", force: :cascade do |t|
    t.text "comment", default: "", null: false
    t.integer "likes_count", default: 0
    t.bigint "user_id", null: false
    t.bigint "ramen_review_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ramen_review_id"], name: "index_comments_on_ramen_review_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id"], name: "index_likes_on_record"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "ramen_reviews", force: :cascade do |t|
    t.string "soup", default: "", null: false
    t.float "score"
    t.text "review", default: "", null: false
    t.bigint "price", default: 0, null: false
    t.bigint "restaurant_id"
    t.integer "likes_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_ramen_reviews_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "address", default: "", null: false
    t.decimal "latitude", precision: 10, scale: 6, default: "0.0", null: false
    t.decimal "longitude", precision: 10, scale: 6, default: "0.0", null: false
    t.string "name", default: "", null: false
    t.string "jpn_name", default: "", null: false
    t.float "average_score", default: 0.0, null: false
    t.date "year_opened", null: false
    t.string "station", default: ""
    t.string "city", default: "", null: false
    t.string "prefecture", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "review_images", force: :cascade do |t|
    t.integer "sort_order", default: 0
    t.bigint "ramen_review_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ramen_review_id"], name: "index_review_images_on_ramen_review_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "comments", "ramen_reviews"
  add_foreign_key "comments", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "ramen_reviews", "restaurants"
  add_foreign_key "review_images", "ramen_reviews"
end
