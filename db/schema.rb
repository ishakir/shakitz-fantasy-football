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

ActiveRecord::Schema.define(version: 20141228021327) do

  create_table "fixtures", force: true do |t|
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_week_team_players", force: true do |t|
    t.integer  "game_week_team_id"
    t.integer  "match_player_id"
    t.boolean  "playing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_week_team_players", ["game_week_team_id"], name: "index_game_week_team_players_on_game_week_team_id"
  add_index "game_week_team_players", ["match_player_id"], name: "index_game_week_team_players_on_match_player_id"

  create_table "game_week_teams", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_week_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_week_teams", ["user_id"], name: "index_game_week_teams_on_user_id"

  create_table "game_weeks", force: true do |t|
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "match_players", force: true do |t|
    t.integer  "passing_yards",        default: 0
    t.integer  "passing_tds",          default: 0
    t.integer  "passing_twoptm",       default: 0
    t.integer  "rushing_yards",        default: 0
    t.integer  "rushing_tds",          default: 0
    t.integer  "rushing_twoptm",       default: 0
    t.integer  "receiving_yards",      default: 0
    t.integer  "receiving_tds",        default: 0
    t.integer  "receiving_twoptm",     default: 0
    t.integer  "times_sacked",         default: 0
    t.integer  "fumbles_lost",         default: 0
    t.integer  "interceptions_thrown", default: 0
    t.integer  "field_goals_kicked",   default: 0
    t.integer  "extra_points_kicked",  default: 0
    t.integer  "sacks_made",           default: 0
    t.integer  "defense_touchdowns",   default: 0
    t.integer  "fumbles_won",          default: 0
    t.integer  "interceptions_caught", default: 0
    t.integer  "points_conceded",      default: 0
    t.integer  "points",               default: 0
    t.integer  "game_week_id"
    t.integer  "nfl_player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nfl_player_types", force: true do |t|
    t.string   "position_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nfl_players", force: true do |t|
    t.string   "name"
    t.string   "nfl_id"
    t.integer  "nfl_team_id"
    t.integer  "nfl_player_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nfl_teams", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfer_requests", force: true do |t|
    t.integer  "offering_user_id"
    t.integer  "target_user_id"
    t.integer  "offered_player_id"
    t.integer  "target_player_id"
    t.string   "status",            default: "pending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transfer_requests", ["offered_player_id"], name: "index_transfer_requests_on_offered_player_id"
  add_index "transfer_requests", ["offering_user_id"], name: "index_transfer_requests_on_offering_user_id"
  add_index "transfer_requests", ["target_player_id"], name: "index_transfer_requests_on_target_player_id"
  add_index "transfer_requests", ["target_user_id"], name: "index_transfer_requests_on_target_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "team_name"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "waiver_wires", force: true do |t|
    t.integer  "user_id"
    t.integer  "player_out_id"
    t.integer  "player_in_id"
    t.integer  "incoming_priority"
    t.integer  "game_week_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "waiver_wires", ["game_week_id"], name: "index_waiver_wires_on_game_week_id"
  add_index "waiver_wires", ["player_in_id"], name: "index_waiver_wires_on_player_in_id"
  add_index "waiver_wires", ["player_out_id"], name: "index_waiver_wires_on_player_out_id"
  add_index "waiver_wires", ["user_id"], name: "index_waiver_wires_on_user_id"

end
