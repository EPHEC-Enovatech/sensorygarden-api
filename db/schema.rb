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

ActiveRecord::Schema.define(version: 2018_10_04_065431) do

  create_table "data", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "device_id"
    t.timestamp "timestamp", null: false
    t.bigint "sensor_id"
    t.float "data", null: false
    t.index ["device_id"], name: "fk_rails_194e9e031e"
    t.index ["sensor_id"], name: "fk_rails_fee73dbcd1"
  end

  create_table "devices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.string "deviceName", default: "Unnamed device", null: false
    t.index ["user_id"], name: "fk_rails_410b63ef65"
  end

  create_table "sensors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "sensorName", null: false
    t.string "sensorUnit", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nom", null: false
    t.string "prenom", null: false
    t.string "mail", null: false
  end

  add_foreign_key "data", "devices"
  add_foreign_key "data", "sensors"
  add_foreign_key "devices", "users"
end
