# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160209231813) do

  create_table "boxes", force: :cascade do |t|
    t.integer  "x"
    t.integer  "y"
    t.string   "paths"
    t.boolean  "explored"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "grid_id"
  end

  add_index "boxes", ["grid_id"], name: "index_boxes_on_grid_id"

  create_table "descriptions", force: :cascade do |t|
    t.string   "name"
    t.string   "text"
    t.string   "url"
    t.string   "background_color"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "box_id"
    t.integer  "npc_id"
  end

  add_index "descriptions", ["box_id"], name: "index_descriptions_on_box_id"
  add_index "descriptions", ["npc_id"], name: "index_descriptions_on_npc_id"

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "games", ["user_id"], name: "index_games_on_user_id"

  create_table "grids", force: :cascade do |t|
    t.integer  "length"
    t.integer  "width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "game_id"
  end

  add_index "grids", ["game_id"], name: "index_grids_on_game_id"

  create_table "npcs", force: :cascade do |t|
    t.integer  "current_box_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "grid_id"
  end

  add_index "npcs", ["grid_id"], name: "index_npcs_on_grid_id"

  create_table "players", force: :cascade do |t|
    t.string   "name"
    t.integer  "current_box_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "game_id"
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
