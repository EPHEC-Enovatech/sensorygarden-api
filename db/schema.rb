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

  create_table "data_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "device_id"
    t.timestamp "timestamp", null: false
    t.bigint "sensor_id"
    t.float "data", null: false
    t.index ["device_id"], name: "fk_rails_26f636d8c3"
    t.index ["sensor_id"], name: "fk_rails_72d8cc27da"
  end

  create_table "devices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "device_id", null: false
    t.bigint "user_id", null: false
    t.string "deviceName", default: "Unnamed device", null: false
    t.index ["device_id"], name: "index_devices_on_device_id", unique: true
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

  add_foreign_key "data_records", "devices", primary_key: "device_id"
  add_foreign_key "data_records", "sensors"
  add_foreign_key "devices", "users"
end
