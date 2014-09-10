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

ActiveRecord::Schema.define(version: 20140908213246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abilities", force: true do |t|
    t.string   "name"
    t.integer  "ap_cost"
    t.integer  "store_price"
    t.text     "image_url"
    t.integer  "min_level"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "job_id"
  end

  add_index "abilities", ["job_id"], name: "index_abilities_on_job_id", using: :btree

  create_table "ability_effects", force: true do |t|
    t.integer  "ability_id"
    t.integer  "effect_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ability_effects", ["ability_id"], name: "index_ability_effects_on_ability_id", using: :btree
  add_index "ability_effects", ["effect_id"], name: "index_ability_effects_on_effect_id", using: :btree

  create_table "ability_equippings", force: true do |t|
    t.integer  "ability_id"
    t.integer  "monster_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "ability_equippings", ["ability_id"], name: "index_ability_equippings_on_ability_id", using: :btree
  add_index "ability_equippings", ["monster_id"], name: "index_ability_equippings_on_monster_id", using: :btree
  add_index "ability_equippings", ["user_id"], name: "index_ability_equippings_on_user_id", using: :btree

  create_table "ability_purchases", force: true do |t|
    t.integer  "ability_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ability_purchases", ["ability_id"], name: "index_ability_purchases_on_ability_id", using: :btree
  add_index "ability_purchases", ["user_id"], name: "index_ability_purchases_on_user_id", using: :btree

  create_table "battles", force: true do |t|
    t.string   "outcome"
    t.integer  "user_id"
    t.integer  "reward"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "battles", ["user_id"], name: "index_battles_on_user_id", using: :btree

  create_table "effects", force: true do |t|
    t.string   "name"
    t.string   "modifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "damage"
    t.integer  "target_id"
    t.integer  "element_id"
  end

  add_index "effects", ["element_id"], name: "index_effects_on_element_id", using: :btree
  add_index "effects", ["target_id"], name: "index_effects_on_target_id", using: :btree

  create_table "elements", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "evolved_states", force: true do |t|
    t.string   "name"
    t.integer  "job_id"
    t.integer  "element_id"
    t.integer  "created_from_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "monster_id"
    t.boolean  "is_template",     default: false
    t.integer  "monster_skin_id"
    t.integer  "hp_modifier"
    t.integer  "dmg_modifier"
  end

  add_index "evolved_states", ["element_id"], name: "index_evolved_states_on_element_id", using: :btree
  add_index "evolved_states", ["job_id"], name: "index_evolved_states_on_job_id", using: :btree
  add_index "evolved_states", ["monster_id"], name: "index_evolved_states_on_monster_id", using: :btree
  add_index "evolved_states", ["monster_skin_id"], name: "index_evolved_states_on_monster_skin_id", using: :btree

  create_table "jobs", force: true do |t|
    t.string   "name"
    t.string   "evolve_lvl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", force: true do |t|
    t.integer  "monster_id"
    t.integer  "party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["monster_id"], name: "index_members_on_monster_id", using: :btree
  add_index "members", ["party_id"], name: "index_members_on_party_id", using: :btree

  create_table "monster_skin_equippings", force: true do |t|
    t.integer  "monster_id"
    t.integer  "monster_skin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monster_skin_equippings", ["monster_id"], name: "index_monster_skin_equippings_on_monster_id", using: :btree
  add_index "monster_skin_equippings", ["monster_skin_id"], name: "index_monster_skin_equippings_on_monster_skin_id", using: :btree

  create_table "monster_skin_purchases", force: true do |t|
    t.integer  "user_id"
    t.integer  "monster_skin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monster_skin_purchases", ["monster_skin_id"], name: "index_monster_skin_purchases_on_monster_skin_id", using: :btree
  add_index "monster_skin_purchases", ["user_id"], name: "index_monster_skin_purchases_on_user_id", using: :btree

  create_table "monster_skins", force: true do |t|
    t.text     "skin_url"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
  end

  add_index "monster_skins", ["job_id"], name: "index_monster_skins_on_job_id", using: :btree

  create_table "monster_unlocks", force: true do |t|
    t.integer  "user_id"
    t.integer  "monster_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monster_unlocks", ["monster_id"], name: "index_monster_unlocks_on_monster_id", using: :btree
  add_index "monster_unlocks", ["user_id"], name: "index_monster_unlocks_on_user_id", using: :btree

  create_table "monsters", force: true do |t|
    t.string   "name"
    t.integer  "max_hp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
    t.integer  "element_id"
    t.integer  "hp_modifier"
    t.integer  "dmg_modifier"
    t.integer  "evolved_from_id"
    t.text     "description"
  end

  add_index "monsters", ["element_id"], name: "index_monsters_on_element_id", using: :btree
  add_index "monsters", ["evolved_from_id"], name: "index_monsters_on_evolved_from_id", using: :btree
  add_index "monsters", ["job_id"], name: "index_monsters_on_job_id", using: :btree

  create_table "parties", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parties", ["user_id"], name: "index_parties_on_user_id", using: :btree

  create_table "summoner_levels", force: true do |t|
    t.integer  "lvl"
    t.integer  "exp_to_nxt_lvl"
    t.integer  "ap"
    t.integer  "monsters_allowed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "summoners", force: true do |t|
    t.string   "name"
    t.integer  "current_lvl"
    t.integer  "current_exp"
    t.integer  "user_id"
    t.integer  "summoner_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "summoners", ["summoner_level_id"], name: "index_summoners_on_summoner_level_id", using: :btree
  add_index "summoners", ["user_id"], name: "index_summoners_on_user_id", using: :btree

  create_table "targets", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_name"
    t.integer  "currency"
    t.integer  "paid_currency"
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
