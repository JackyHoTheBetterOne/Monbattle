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

ActiveRecord::Schema.define(version: 20141014173436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abil_sockets", force: true do |t|
    t.integer  "socket_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abilities", force: true do |t|
    t.string   "name"
    t.integer  "ap_cost"
    t.integer  "store_price"
    t.integer  "min_level"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.string   "stat_change"
    t.integer  "target_id"
    t.integer  "element_id"
    t.integer  "stat_target_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "abil_socket_id"
    t.string   "portrait_file_name"
    t.string   "portrait_content_type"
    t.integer  "portrait_file_size"
    t.datetime "portrait_updated_at"
    t.text     "keywords"
  end

  add_index "abilities", ["abil_socket_id"], name: "index_abilities_on_abil_socket_id", using: :btree
  add_index "abilities", ["element_id"], name: "index_abilities_on_element_id", using: :btree
  add_index "abilities", ["stat_target_id"], name: "index_abilities_on_stat_target_id", using: :btree
  add_index "abilities", ["target_id"], name: "index_abilities_on_target_id", using: :btree

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "monster_unlock_id"
  end

  add_index "ability_equippings", ["ability_id"], name: "index_ability_equippings_on_ability_id", using: :btree
  add_index "ability_equippings", ["monster_unlock_id"], name: "index_ability_equippings_on_monster_unlock_id", using: :btree

  create_table "ability_purchases", force: true do |t|
    t.integer  "ability_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ability_purchases", ["ability_id"], name: "index_ability_purchases_on_ability_id", using: :btree
  add_index "ability_purchases", ["user_id"], name: "index_ability_purchases_on_user_id", using: :btree

  create_table "ability_restrictions", force: true do |t|
    t.integer  "job_id"
    t.integer  "ability_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ability_restrictions", ["ability_id"], name: "index_ability_restrictions_on_ability_id", using: :btree
  add_index "ability_restrictions", ["job_id"], name: "index_ability_restrictions_on_job_id", using: :btree

  create_table "battle_levels", force: true do |t|
    t.string   "item_given"
    t.integer  "exp_given"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "background_file_name"
    t.string   "background_content_type"
    t.integer  "background_file_size"
    t.datetime "background_updated_at"
  end

  create_table "battles", force: true do |t|
    t.string   "outcome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "battle_level_id"
    t.integer  "round_taken"
    t.string   "time_taken"
  end

  add_index "battles", ["battle_level_id"], name: "index_battles_on_battle_level_id", using: :btree

  create_table "effects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "target_id"
    t.integer  "element_id"
    t.string   "stat_change"
    t.integer  "stat_target_id"
    t.text     "keywords"
  end

  add_index "effects", ["element_id"], name: "index_effects_on_element_id", using: :btree
  add_index "effects", ["stat_target_id"], name: "index_effects_on_stat_target_id", using: :btree
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

  create_table "fights", force: true do |t|
    t.integer  "battle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "party_id"
  end

  add_index "fights", ["battle_id"], name: "index_fights_on_battle_id", using: :btree
  add_index "fights", ["party_id"], name: "index_fights_on_party_id", using: :btree

  create_table "jobs", force: true do |t|
    t.string   "name"
    t.string   "evolve_lvl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", force: true do |t|
    t.integer  "party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "monster_unlock_id"
  end

  add_index "members", ["monster_unlock_id"], name: "index_members_on_monster_unlock_id", using: :btree
  add_index "members", ["party_id"], name: "index_members_on_party_id", using: :btree

  create_table "monster_skin_equippings", force: true do |t|
    t.integer  "monster_id"
    t.integer  "monster_skin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "monster_skin_equippings", ["monster_id"], name: "index_monster_skin_equippings_on_monster_id", using: :btree
  add_index "monster_skin_equippings", ["monster_skin_id"], name: "index_monster_skin_equippings_on_monster_skin_id", using: :btree
  add_index "monster_skin_equippings", ["user_id"], name: "index_monster_skin_equippings_on_user_id", using: :btree

  create_table "monster_skin_purchases", force: true do |t|
    t.integer  "user_id"
    t.integer  "monster_skin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "monster_skin_purchases", ["monster_skin_id"], name: "index_monster_skin_purchases_on_monster_skin_id", using: :btree
  add_index "monster_skin_purchases", ["user_id"], name: "index_monster_skin_purchases_on_user_id", using: :btree

  create_table "monster_skins", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "portrait_file_name"
    t.string   "portrait_content_type"
    t.integer  "portrait_file_size"
    t.datetime "portrait_updated_at"
  end

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
    t.integer  "summon_cost"
    t.string   "evolve_animation_file_name"
    t.string   "evolve_animation_content_type"
    t.integer  "evolve_animation_file_size"
    t.datetime "evolve_animation_updated_at"
    t.integer  "personality_id"
    t.text     "keywords"
  end

  add_index "monsters", ["element_id"], name: "index_monsters_on_element_id", using: :btree
  add_index "monsters", ["evolved_from_id"], name: "index_monsters_on_evolved_from_id", using: :btree
  add_index "monsters", ["job_id"], name: "index_monsters_on_job_id", using: :btree
  add_index "monsters", ["personality_id"], name: "index_monsters_on_personality_id", using: :btree

  create_table "parties", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "npc",        default: false
    t.text     "enemy"
  end

  add_index "parties", ["user_id"], name: "index_parties_on_user_id", using: :btree

  create_table "personalities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skin_restrictions", force: true do |t|
    t.integer  "monster_skin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_id"
  end

  add_index "skin_restrictions", ["job_id"], name: "index_skin_restrictions_on_job_id", using: :btree
  add_index "skin_restrictions", ["monster_skin_id"], name: "index_skin_restrictions_on_monster_skin_id", using: :btree

  create_table "stat_targets", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "thoughts", force: true do |t|
    t.integer  "personality_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "thoughts", ["personality_id"], name: "index_thoughts_on_personality_id", using: :btree

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
    t.string   "uid"
    t.string   "provider"
    t.text     "raw_oauth_info"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
