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

ActiveRecord::Schema.define(version: 20140322131730) do

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
    t.integer  "gameweek"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "game_week_teams", ["user_id"], name: "index_game_week_teams_on_user_id"

  create_table "match_players", force: true do |t|
    t.integer  "nfl_player_id"
    t.integer  "passing_yards",    default: 0
    t.integer  "passing_td",       default: 0
    t.integer  "rushing_yards",    default: 0
    t.integer  "rushing_td",       default: 0
    t.integer  "point_conversion", default: 0
    t.integer  "offensive_sack",   default: 0
    t.integer  "offensive_safety", default: 0
    t.integer  "fumble",           default: 0
    t.integer  "qb_pick",          default: 0
    t.integer  "defensive_sack",   default: 0
    t.integer  "defensive_td",     default: 0
    t.integer  "defensive_safety", default: 0
    t.integer  "turnover",         default: 0
    t.integer  "defensive_yards",  default: 0
    t.integer  "defensive_points", default: 0
    t.integer  "kicker_points",    default: 0
    t.integer  "blocked_kicks",    default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nfl_players", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "team_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
