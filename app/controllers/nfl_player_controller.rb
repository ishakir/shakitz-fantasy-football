# -*- encoding : utf-8 -*-
require 'player_finder'
require 'response_message'

class NflPlayerController < ApplicationController
  PLAYER_JSON_KEY = :player
  ID_INFO_KEY     = :id_info
  GAME_WEEK_KEY   = :game_week
  STATS_KEY       = :stats

  NAME_KEY = :name
  TEAM_KEY = :team
  TYPE_KEY = :type
  NFL_ID_KEY = :nfl_id

  def unpicked
    @players = NflPlayer.all
    picked_players = GameWeekTeamPlayer.all

    @unpicked_players = @players.select do |player|
      !picked_players.any? do |active_player|
        active_player.match_player.nfl_player_id == player.id
      end
    end
  end

  def show
    id = params[:id]
    @player = NflPlayer.find(id)
  end

  def create
    validate_all_parameters([NAME_KEY, TEAM_KEY, TYPE_KEY], params)

    type = params[TYPE_KEY]

    player = create_defence_player(params) if type == "D"
    player = create_non_defence_player(params) if type != "D"

    MatchPlayer.create!(
      game_week: GameWeek.find_unique_with(1),
      nfl_player: player
    )
  end

  def create_defence_player(params)
    fail ArgumentError if params.key?(NFL_ID_KEY)

    team = find_team_from_name(params[TEAM_KEY])
    type = find_type_from_name(params[TYPE_KEY])
    name = params[NAME_KEY]

    NflPlayer.create!(
      name: name,
      nfl_team: team,
      nfl_player_type: type
    )
  end

  def create_non_defence_player(params)
    validate_all_parameters([NFL_ID_KEY], params)

    team = find_team_from_name(params[TEAM_KEY])
    type = find_type_from_name(params[TYPE_KEY])
    name = params[NAME_KEY]
    nfl_id = params[NFL_ID_KEY]

    NflPlayer.create!(
      name: name,
      nfl_team: team,
      nfl_player_type: type,
      nfl_id: nfl_id
    )
  end

  def find_team_from_name(team_name)
    teams = NflTeam.where(name: team_name)
    fail ActiveRecord::RecordNotFound if teams.size != 1
    teams.first
  end

  def find_type_from_name(type)
    types = NflPlayerType.where(position_type: type)
    fail ActiveRecord::RecordNotFound if types.size != 1
    types.first
  end

  def on_game_week
    id = params[:id]
    game_week = params[:game_week]
    player = NflPlayer.find(id)
    @match_player = player.player_for_game_week(game_week)
  end

  def update_stats
    # Setup the messages to return
    message = ApplicationController::ResponseMessage.new

    # Check that player json is a thing
    return add_no_id_info_error_message_and_respond(message) unless params_validated?(params)

    id_json = params[PLAYER_JSON_KEY][ID_INFO_KEY]

    player_finder = PlayerFinder.new(id_json)

    if player_finder == :only_team
      return handle_only_team(message)
    elsif player_finder == :only_type
      return handle_only_type(message)
    end

    found_player = player_finder.player
    if found_player == :none
      # TODO: remove this! Currently left in to do
      # team = NflTeam.where(name: id_json['team']).first
      # position_type = NflPlayerType.where(position_type: id_json['type']).first
      # found_player = NflPlayer.new(name: id_json['name'], nfl_team: team, nfl_player_type: position_type)
      # found_player.nfl_id = id_json['id']
      # found_player.save!
      # 1.upto(17) do |game_week|
      #   MatchPlayer.create!(nfl_player: found_player, game_week: GameWeek.where(number: game_week).first)
      # end
      # message.add_message(0, "Added player (demo mode)")
      player_finder.add_no_player_found_message(message)
      return respond(message, :not_found)
    elsif found_player == :too_many
      player_finder.add_multiple_players_found_message(message)
      return respond(message, :not_found)
    end

    # If there are any inconsistancies, flag them
    player_finder.add_inconsistancy_messages(message)
    match_player = found_player.player_for_game_week(params[GAME_WEEK_KEY])
    update_stats_for_player(match_player, params[PLAYER_JSON_KEY][STATS_KEY])

    respond(message, :ok)
  end

  def handle_only_team(message)
    message.add_message(2, "Only 'team' was provided to identify the player, please specify one of id, name with team, type or both, or team and type")
    respond(message, :unprocessable_entity)
  end

  def handle_only_type(message)
    message.add_message(3, "Only 'type' was provided to identify the player, please specify one of id, name with team, type or both, or team and type")
    respond(message, :unprocessable_entity)
  end

  def update_stats_for_player(match_player, stats)
    return if stats.nil?
    all_stats_hash = stats.values.reduce(Hash.new) do |acc_hash, value|
      acc_hash.merge(value)
    end
    match_player.assign_attributes(all_stats_hash)
    match_player.save!
  end

  def params_validated?(params)
    begin
      validate_all_parameters([PLAYER_JSON_KEY], params)
      return false unless params[PLAYER_JSON_KEY].key?(ID_INFO_KEY) && !params[PLAYER_JSON_KEY][ID_INFO_KEY].empty?
    rescue ArgumentError
      return false
    end
    true
  end

  def respond(message, response_code)
    respond_to do |format|
      format.json { render json: message, status: response_code }
    end
  end

  def add_no_id_info_error_message_and_respond(message)
    message.add_message(1, "No attributes were provided to identify the player, please specify one of id, name with team, type or both, or team and type")
    respond(message, :unprocessable_entity)
  end
end
