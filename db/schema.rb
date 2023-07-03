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

ActiveRecord::Schema[7.0].define(version: 2023_07_03_041000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "timescaledb"

  create_table "audit_models", id: false, force: :cascade do |t|
    t.text "auditable_type", null: false
    t.bigint "auditable_id", null: false
    t.timestamptz "audit_timestamp", null: false
    t.text "audit_column", null: false
    t.text "audit_data"
    t.integer "action", limit: 2, null: false
    t.integer "severity", limit: 2, null: false
    t.bigint "user_id", null: false
    t.index ["audit_timestamp"], name: "audit_models_audit_timestamp_idx", order: :desc
    t.index ["auditable_type", "auditable_id", "audit_timestamp", "audit_column"], name: "index_audit_models_on_auditable_and_timestamp_and_column", unique: true
    t.index ["user_id"], name: "index_audit_models_on_user_id"
  end

  create_table "user_actions", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.timestamptz "timestamp", null: false
    t.integer "action", limit: 2, null: false
    t.integer "severity", limit: 2, null: false
    t.inet "ip_address"
    t.integer "response_code", limit: 2
    t.jsonb "data"
    t.index ["action"], name: "index_user_actions_on_action"
    t.index ["ip_address"], name: "index_user_actions_on_ip_address"
    t.index ["severity"], name: "index_user_actions_on_severity"
    t.index ["timestamp"], name: "user_actions_timestamp_idx", order: :desc
    t.index ["user_id", "timestamp"], name: "index_user_actions_on_user_id_and_timestamp", unique: true
    t.index ["user_id"], name: "index_user_actions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id", null: false
    t.bigint "updated_by_id", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["created_by_id"], name: "index_users_on_created_by_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["updated_by_id"], name: "index_users_on_updated_by_id"
  end

  add_foreign_key "audit_models", "users"
  add_foreign_key "user_actions", "users"
  add_foreign_key "users", "users", column: "created_by_id"
  add_foreign_key "users", "users", column: "updated_by_id"
end
