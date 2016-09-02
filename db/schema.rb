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

ActiveRecord::Schema.define(version: 20160902103155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.string   "delivery_date"
    t.string   "delivery_shift"
    t.string   "origin_name"
    t.string   "origin_raw_line_1"
    t.string   "origin_city"
    t.string   "origin_state"
    t.string   "origin_zip"
    t.string   "origin_country"
    t.string   "client_name"
    t.string   "destination_raw_line_1"
    t.string   "destination_city"
    t.string   "destination_state"
    t.string   "destination_zip"
    t.string   "destination_country"
    t.string   "phone_number"
    t.string   "mode"
    t.string   "purchase_order_number"
    t.string   "volume"
    t.string   "handling_unit_quantity"
    t.string   "handling_unit_type"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            null: false
    t.string   "login",           null: false
    t.string   "password_digest", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["login"], name: "index_users_on_login", unique: true, using: :btree
  end

end
