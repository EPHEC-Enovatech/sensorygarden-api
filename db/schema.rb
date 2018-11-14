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

ActiveRecord::Schema.define(version: 2018_11_14_183028) do

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "categoryName", null: false
    t.index ["categoryName"], name: "index_categories_on_categoryName", unique: true
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "commentText", null: false
    t.timestamp "commentDate", null: false
    t.index ["user_id"], name: "fk_rails_03de2dc08c"
  end

  create_table "comments_posts", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "comment_id", null: false
    t.index ["comment_id"], name: "index_comments_posts_on_comment_id"
    t.index ["post_id"], name: "index_comments_posts_on_post_id"
  end

  create_table "data_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "device_id", null: false
    t.timestamp "timestamp", null: false
    t.bigint "sensor_id", null: false
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

  create_table "posts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "postTitle", null: false
    t.bigint "user_id", null: false
    t.text "postText", null: false
    t.timestamp "postDate", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "fk_rails_9b1b26f040"
    t.index ["user_id"], name: "fk_rails_5b5ddfd518"
  end

  create_table "sensors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "sensorName", null: false
    t.string "sensorUnit", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "nom", null: false
    t.string "prenom", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.boolean "confirm_email", default: false
  end

  add_foreign_key "comments", "users", on_delete: :cascade
  add_foreign_key "comments_posts", "comments", on_delete: :cascade
  add_foreign_key "comments_posts", "posts", on_delete: :cascade
  add_foreign_key "data_records", "devices", primary_key: "device_id", on_delete: :cascade
  add_foreign_key "data_records", "sensors", on_delete: :cascade
  add_foreign_key "devices", "users", on_delete: :cascade
  add_foreign_key "posts", "categories", on_delete: :cascade
  add_foreign_key "posts", "users", on_delete: :cascade
end
