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

ActiveRecord::Schema[7.1].define(version: 2024_06_23_071944) do
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
  end

  create_table "expenses", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "expense_group_id", null: false
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

  add_foreign_key "debtors", "expenses"
  add_foreign_key "expenses", "expense_groups"
  add_foreign_key "payers", "expenses"
end
