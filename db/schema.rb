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

ActiveRecord::Schema[7.1].define(version: 2024_09_06_064914) do
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

  create_table "debtors", force: :cascade do |t|
    t.string "name"
    t.decimal "amount", precision: 8, scale: 2, default: "0.0"
    t.integer "expense_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_debtors_on_expense_id"
  end

  create_table "expense_groups", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_settled", default: false
  end

  create_table "expenses", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "expense_group_id", null: false
    t.decimal "amount_per_participant", default: "0.0"
    t.index ["expense_group_id"], name: "index_expenses_on_expense_group_id"
  end

  create_table "payers", force: :cascade do |t|
    t.string "name"
    t.decimal "amount", precision: 8, scale: 2, default: "0.0"
    t.integer "expense_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "exclude"
    t.index ["expense_id"], name: "index_payers_on_expense_id"
  end

  create_table "price_histories", force: :cascade do |t|
    t.string "f_date"
    t.string "f_series"
    t.string "f_open"
    t.string "f_high"
    t.string "f_low"
    t.string "f_prev_close"
    t.string "f_ltp"
    t.string "f_close"
    t.string "f_vwap"
    t.string "f_52wh"
    t.string "f_52wl"
    t.string "f_volume"
    t.string "f_value"
    t.string "f_no_trades"
    t.integer "stock_id", null: false
    t.index ["stock_id"], name: "index_price_histories_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.string "script"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "debtors", "expenses"
  add_foreign_key "expenses", "expense_groups"
  add_foreign_key "payers", "expenses"
  add_foreign_key "price_histories", "stocks"
end
