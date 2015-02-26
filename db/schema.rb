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

ActiveRecord::Schema.define(version: 20150226235238) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "abil_sockets", force: true do |t|
    t.integer  "socket_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "abilities", force: true do |t|
    t.string   "name"
    t.integer  "ap_cost"
    t.integer  "min_level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.string   "stat_change",           default: ""
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
    t.integer  "rarity_id"
    t.boolean  "is_featured"
    t.integer  "minimum"
    t.integer  "maximum"
  end

  add_index "abilities", ["abil_socket_id"], name: "index_abilities_on_abil_socket_id", using: :btree
  add_index "abilities", ["element_id"], name: "index_abilities_on_element_id", using: :btree
  add_index "abilities", ["rarity_id"], name: "index_abilities_on_rarity_id", using: :btree
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
    t.integer  "monster_unlock_id", default: 0
    t.integer  "socket_num"
    t.integer  "learner_id"
    t.string   "id_code"
  end

  add_index "ability_purchases", ["ability_id"], name: "index_ability_purchases_on_ability_id", using: :btree
  add_index "ability_purchases", ["monster_unlock_id"], name: "index_ability_purchases_on_monster_unlock_id", using: :btree
  add_index "ability_purchases", ["user_id"], name: "index_ability_purchases_on_user_id", using: :btree

  create_table "ability_restrictions", force: true do |t|
    t.integer  "job_id"
    t.integer  "ability_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ability_restrictions", ["ability_id"], name: "index_ability_restrictions_on_ability_id", using: :btree
  add_index "ability_restrictions", ["job_id"], name: "index_ability_restrictions_on_job_id", using: :btree

  create_table "arcs", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "areas", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unlocked_by_id"
    t.integer  "region_id"
    t.text     "keywords"
    t.integer  "order"
  end

  add_index "areas", ["region_id"], name: "index_areas_on_region_id", using: :btree

  create_table "backgrounds", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "battle_levels", force: true do |t|
    t.integer  "exp_given"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "mp_reward",        default: 0
    t.integer  "gp_reward",        default: 0
    t.integer  "vk_reward",        default: 0
    t.integer  "unlocked_by_id"
    t.integer  "area_id"
    t.text     "keywords"
    t.text     "description"
    t.text     "victory_message"
    t.text     "ability_reward",   default: [], array: true
    t.integer  "stamina_cost",     default: 0
    t.string   "background"
    t.string   "music"
    t.integer  "time_requirement"
    t.integer  "asp_reward",       default: 0
    t.integer  "enh_reward",       default: 0
    t.integer  "order"
  end

  add_index "battle_levels", ["area_id"], name: "index_battle_levels_on_area_id", using: :btree

  create_table "battles", force: true do |t|
    t.string   "outcome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "battle_level_id"
    t.integer  "round_taken"
    t.string   "id_code"
    t.string   "slug"
    t.string   "victor"
    t.string   "loser"
    t.string   "aasm_state"
    t.text     "after_action_state"
    t.text     "before_action_state"
    t.boolean  "is_hacked",           default: true
    t.date     "finished"
    t.integer  "time_taken"
    t.boolean  "admin",               default: false
    t.string   "session_id"
  end

  add_index "battles", ["battle_level_id"], name: "index_battles_on_battle_level_id", using: :btree
  add_index "battles", ["slug"], name: "index_battles_on_slug", unique: true, using: :btree

  create_table "chapters", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "arc_id"
  end

  add_index "chapters", ["arc_id"], name: "index_chapters_on_arc_id", using: :btree

  create_table "cut_scenes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "to_start"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "chapter_id"
    t.integer  "battle_level_id"
    t.integer  "order"
    t.text     "keywords"
  end

  add_index "cut_scenes", ["battle_level_id"], name: "index_cut_scenes_on_battle_level_id", using: :btree
  add_index "cut_scenes", ["chapter_id"], name: "index_cut_scenes_on_chapter_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "effects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "target_id"
    t.integer  "element_id"
    t.string   "stat_change",    default: ""
    t.integer  "stat_target_id"
    t.text     "keywords"
    t.integer  "duration",       default: 0
    t.string   "restore",        default: "0"
    t.text     "description"
    t.string   "icon",           default: "https://s3-us-west-2.amazonaws.com/monbattle/images/frank.jpg"
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
    t.boolean  "winner",     default: false
  end

  add_index "fights", ["battle_id"], name: "index_fights_on_battle_id", using: :btree
  add_index "fights", ["party_id"], name: "index_fights_on_party_id", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "impressions", force: true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "jobs", force: true do |t|
    t.string   "name"
    t.string   "evolve_lvl"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "learned_abilities", force: true do |t|
    t.integer  "monster_unlock_id"
    t.integer  "ability_id"
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

  create_table "monster_assignments", force: true do |t|
    t.integer  "monster_id"
    t.integer  "battle_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.integer  "rarity_id"
    t.text     "former_name",           default: ""
  end

  add_index "monster_skins", ["rarity_id"], name: "index_monster_skins_on_rarity_id", using: :btree

  create_table "monster_unlocks", force: true do |t|
    t.integer  "user_id"
    t.integer  "monster_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "id_code"
    t.integer  "level",      default: 0
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
    t.integer  "rarity_id"
    t.integer  "default_skin_id"
    t.integer  "default_sock1_id"
    t.integer  "default_sock2_id"
    t.string   "stage"
    t.integer  "default_sock3_id"
    t.integer  "default_sock4_id"
    t.integer  "passive_id"
    t.integer  "asp_cost",                      default: 10
    t.integer  "max_level",                     default: 10
  end

  add_index "monsters", ["element_id"], name: "index_monsters_on_element_id", using: :btree
  add_index "monsters", ["evolved_from_id"], name: "index_monsters_on_evolved_from_id", using: :btree
  add_index "monsters", ["job_id"], name: "index_monsters_on_job_id", using: :btree
  add_index "monsters", ["personality_id"], name: "index_monsters_on_personality_id", using: :btree
  add_index "monsters", ["rarity_id"], name: "index_monsters_on_rarity_id", using: :btree

  create_table "notice_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notices", force: true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notice_type_id"
    t.text     "keywords"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "description_image_file_name"
    t.string   "description_image_content_type"
    t.integer  "description_image_file_size"
    t.datetime "description_image_updated_at"
    t.boolean  "is_active",                      default: true
  end

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

  create_table "quest_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quests", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "stat"
    t.integer  "requirement"
    t.boolean  "is_active",          default: true
    t.string   "bonus"
    t.integer  "reward_amount"
    t.datetime "end_date",           default: '2015-11-24 06:45:56'
    t.datetime "refresh_date",       default: '2015-11-24 06:45:56'
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quest_type_id"
    t.integer  "reward_category_id"
    t.text     "keywords"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.integer  "stat_requirement"
    t.text     "message"
  end

  add_index "quests", ["quest_type_id"], name: "index_quests_on_quest_type_id", using: :btree
  add_index "quests", ["reward_category_id"], name: "index_quests_on_reward_category_id", using: :btree

  create_table "rarities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "chance"
  end

  create_table "regions", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unlocked_by_id"
    t.string   "map_file_name"
    t.string   "map_content_type"
    t.integer  "map_file_size"
    t.datetime "map_updated_at"
    t.text     "keywords"
    t.integer  "order"
  end

  create_table "reward_categories", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level"
    t.integer  "stamina"
    t.integer  "exp_required_for_next_level"
  end

  create_table "summoners", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mp",                           default: 0
    t.integer  "gp",                           default: 0
    t.integer  "current_exp",                  default: 0
    t.integer  "vortex_key",                   default: 0
    t.integer  "wins",                         default: 0
    t.integer  "losses",                       default: 0
    t.hstore   "starting_status"
    t.hstore   "ending_status"
    t.text     "completed_daily_quests",       default: [],                    array: true
    t.text     "completed_weekly_quests",      default: [],                    array: true
    t.text     "completed_quests",             default: [],                    array: true
    t.text     "daily_battles",                default: [],                    array: true
    t.text     "beaten_levels",                default: [],                    array: true
    t.text     "recently_completed_quests",    default: [],                    array: true
    t.integer  "stamina",                      default: 15
    t.integer  "seconds_left_for_next_energy"
    t.datetime "last_update_for_energy",       default: '2014-12-09 21:13:37'
    t.text     "completed_areas",              default: [],                    array: true
    t.text     "completed_regions",            default: [],                    array: true
    t.string   "recently_unlocked_level",      default: ""
    t.string   "code"
    t.text     "played_levels",                default: [],                    array: true
    t.string   "latest_level",                 default: "AreaA-Stage1"
    t.text     "cleared_twice_levels",         default: [],                    array: true
    t.text     "cleared_thrice_levels",        default: [],                    array: true
    t.text     "just_achieved_quests",         default: [],                    array: true
    t.integer  "summoner_level_id",            default: 1
    t.integer  "exp_to_gain"
    t.integer  "asp",                          default: 0
    t.integer  "enh",                          default: 0
  end

  add_index "summoners", ["user_id"], name: "index_summoners_on_user_id", using: :btree

  create_table "target_categories", force: true do |t|
    t.integer  "target_type_id"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "target_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
    t.string   "uid"
    t.string   "provider"
    t.text     "raw_oauth_info"
    t.text     "image"
    t.string   "namey"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
