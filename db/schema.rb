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

ActiveRecord::Schema.define(version: 20140430112835) do

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
    t.integer  "passing_yards",       default: 0
    t.integer  "passing_td",          default: 0
    t.integer  "passing_twopt",       default: 0
    t.integer  "rushing_yards",       default: 0
    t.integer  "rushing_td",          default: 0
    t.integer  "rushing_twopt",       default: 0
    t.integer  "receiving_yards",     default: 0
    t.integer  "receiving_td",        default: 0
    t.integer  "receiving_twopt",     default: 0
    t.integer  "offensive_sack",      default: 0
    t.integer  "offensive_safety",    default: 0
    t.integer  "fumble",              default: 0
    t.integer  "qb_pick",             default: 0
    t.integer  "defensive_sack",      default: 0
    t.integer  "defensive_td",        default: 0
    t.integer  "defensive_safety",    default: 0
    t.integer  "turnover",            default: 0
    t.integer  "defensive_yards",     default: 0
    t.integer  "defensive_points",    default: 0
    t.integer  "field_goals_kicked",  default: 0
    t.integer  "extra_points_kicked", default: 0
    t.integer  "blocked_kicks",       default: 0
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

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "team_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
