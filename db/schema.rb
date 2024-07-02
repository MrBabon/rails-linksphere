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

ActiveRecord::Schema[7.0].define(version: 2024_07_02_152222) do
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

  create_table "blocks", force: :cascade do |t|
    t.bigint "blocker_id", null: false
    t.bigint "blocked_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked_id"], name: "index_blocks_on_blocked_id"
    t.index ["blocker_id", "blocked_id"], name: "index_blocks_on_blocker_id_and_blocked_id", unique: true
    t.index ["blocker_id"], name: "index_blocks_on_blocker_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.bigint "user1_id", null: false
    t.bigint "user2_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user1_id"], name: "index_chatrooms_on_user1_id"
    t.index ["user2_id"], name: "index_chatrooms_on_user2_id"
  end

  create_table "contact_groups", force: :cascade do |t|
    t.string "name"
    t.boolean "deletable"
    t.bigint "repertoire_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repertoire_id"], name: "index_contact_groups_on_repertoire_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "role"
    t.bigint "user_id", null: false
    t.bigint "entreprise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entreprise_id"], name: "index_employees_on_entreprise_id"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "entrepreneurs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "entreprise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entreprise_id"], name: "index_entrepreneurs_on_entreprise_id"
    t.index ["user_id"], name: "index_entrepreneurs_on_user_id"
  end

  create_table "entreprise_contact_groups", force: :cascade do |t|
    t.bigint "repertoire_id", null: false
    t.bigint "entreprise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entreprise_id"], name: "index_entreprise_contact_groups_on_entreprise_id"
    t.index ["repertoire_id"], name: "index_entreprise_contact_groups_on_repertoire_id"
  end

  create_table "entreprises", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "website"
    t.string "linkedin"
    t.string "instagram"
    t.string "facebook"
    t.string "twitter"
    t.string "headline"
    t.string "industry"
    t.text "description"
    t.string "siret"
    t.string "tva"
    t.string "address"
    t.string "phone"
    t.datetime "establishment"
    t.string "legal_status"
    t.float "latitude"
    t.float "longitude"
    t.string "country"
    t.string "city"
    t.string "region"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.string "city"
    t.string "country"
    t.string "region"
    t.string "link"
    t.text "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "registration_code"
    t.boolean "is_published", default: false, null: false
    t.bigint "entreprise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "industry"
    t.index ["entreprise_id"], name: "index_events_on_entreprise_id"
  end

  create_table "exhibitors", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "entreprise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entreprise_id"], name: "index_exhibitors_on_entreprise_id"
    t.index ["event_id"], name: "index_exhibitors_on_event_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "chatroom_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "participations", force: :cascade do |t|
    t.boolean "visible_in_participants", default: false, null: false
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_participations_on_event_id"
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "repertoires", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_repertoires_on_user_id"
  end

  create_table "user_contact_groups", force: :cascade do |t|
    t.text "personal_note"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_user_id"
    t.index ["current_user_id"], name: "index_user_contact_groups_on_current_user_id"
    t.index ["user_id", "current_user_id"], name: "index_user_contact_groups_on_user_and_current_user", unique: true
    t.index ["user_id"], name: "index_user_contact_groups_on_user_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.bigint "user_contact_group_id", null: false
    t.bigint "contact_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_group_id"], name: "index_user_groups_on_contact_group_id"
    t.index ["user_contact_group_id"], name: "index_user_groups_on_user_contact_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin", default: false, null: false
    t.string "phone"
    t.string "job"
    t.text "biography"
    t.string "industry"
    t.string "website"
    t.string "linkedin"
    t.string "instagram"
    t.string "facebook"
    t.string "twitter"
    t.text "qr_code"
    t.boolean "push_notifications", default: false
    t.boolean "messages_from_contacts", default: false
    t.boolean "messages_from_everyone", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blocks", "users", column: "blocked_id"
  add_foreign_key "blocks", "users", column: "blocker_id"
  add_foreign_key "chatrooms", "users", column: "user1_id"
  add_foreign_key "chatrooms", "users", column: "user2_id"
  add_foreign_key "contact_groups", "repertoires"
  add_foreign_key "employees", "entreprises"
  add_foreign_key "employees", "users"
  add_foreign_key "entrepreneurs", "entreprises"
  add_foreign_key "entrepreneurs", "users"
  add_foreign_key "entreprise_contact_groups", "entreprises"
  add_foreign_key "entreprise_contact_groups", "repertoires"
  add_foreign_key "events", "entreprises"
  add_foreign_key "exhibitors", "entreprises"
  add_foreign_key "exhibitors", "events"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
  add_foreign_key "participations", "events"
  add_foreign_key "participations", "users"
  add_foreign_key "repertoires", "users"
  add_foreign_key "user_contact_groups", "users", column: "current_user_id", on_delete: :cascade
  add_foreign_key "user_contact_groups", "users", on_delete: :cascade
  add_foreign_key "user_groups", "contact_groups"
  add_foreign_key "user_groups", "user_contact_groups"
end
