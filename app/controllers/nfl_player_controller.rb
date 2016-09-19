# -*- encoding : utf-8 -*-
require 'player_finder'
require 'response_message'
require 'points_strategy'

class NflPlayerController < ApplicationController
  PLAYER_JSON_KEY = :player
  ID_INFO_KEY     = :id_info
  GAME_WEEK_KEY   = :game_week
  STATS_KEY       = :stats

  ID_KEY      = :id
  NAME_KEY    = :name
  TEAM_KEY    = :team
  TYPE_KEY    = :type
  NFL_ID_KEY  = :id

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

  def update
    validate_at_least_number_of_parameters([NAME_KEY, TEAM_KEY, TYPE_KEY], params, 1)
    nfl_player = NflPlayer.find(params[ID_KEY])

    update_player(nfl_player, params)

    render json: { status: 'success' }
  end

  def create
    validate_all_parameters([NAME_KEY, TEAM_KEY, TYPE_KEY], params)

    type = params[TYPE_KEY]

    player = create_defence_player(params) if type == 'D'
    player = create_non_defence_player(params) if type != 'D'

    create_all_match_players(player)
  end

  def on_game_week
    id = params[:id]
    game_week = params[:game_week]
    player = NflPlayer.find(id)
    @match_player = player.player_for_game_week(game_week)
  end

  def update_stats
    # Setup the messages to return
    message = ResponseMessage.new

    # Check that player json is a thing
    return add_no_id_info_error_message_and_respond(message) unless params_validated?(params)

    id_json = params[PLAYER_JSON_KEY][ID_INFO_KEY]
    player_finder = PlayerFinder.new(id_json)

    return handle_only_team(message) if player_finder == :only_team
    return handle_only_type(message) if player_finder == :only_type

    process_found_player(params, player_finder, message)
  end

  private

  def update_player(nfl_player, params)
    nfl_player.name = params[NAME_KEY] if params.key?(NAME_KEY)
    nfl_player.nfl_team = find_team_from_name(params[TEAM_KEY]) if params.key?(TEAM_KEY)
    nfl_player.nfl_player_type = find_type_from_name(params[TYPE_KEY]) if params.key?(TYPE_KEY)
    nfl_player.save!
  end

  def create_defence_player(params)
    raise ArgumentError if params.key?(NFL_ID_KEY)

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

    NflPlayer.create!(
      name: params[NAME_KEY],
      nfl_team: team,
      nfl_player_type: type,
      nfl_id: params[NFL_ID_KEY]
    )
  end

  def create_all_match_players(player)
    all_game_weeks = GameWeek.all
    all_game_weeks.each do |game_week|
      MatchPlayer.create!(
        game_week: game_week,
        nfl_player: player
      )
    end
  end

  def find_team_from_name(team_name)
    teams = NflTeam.where(name: team_name)
    raise ActiveRecord::RecordNotFound if teams.size != 1
    teams.first
  end

  def find_type_from_name(type)
    types = NflPlayerType.where(position_type: type)
    raise ActiveRecord::RecordNotFound if types.size != 1
    types.first
  end

  def handle_only_team(message)
    message.add_message(
      2,
      "Only 'team' was provided to identify the player, please specify one of id," \
      ' name with team, type or both, or team and type'
    )
    respond(message, :unprocessable_entity)
  end

  def handle_only_type(message)
    message.add_message(
      3,
      "Only 'type' was provided to identify the player, please specify one of id," \
      ' name with team, type or both, or team and type'
    )
    respond(message, :unprocessable_entity)
  end

  def process_found_player(params, player_finder, message)
    found_player = player_finder.player
    if found_player == :none || found_player == :too_many
      return add_no_player_error_message_and_respond(message, found_player, player_finder)
    end

    # If there are any inconsistancies, flag them
    player_finder.add_inconsistancy_messages(message)
    commit_stats_update_for_player(params[GAME_WEEK_KEY], params[PLAYER_JSON_KEY][STATS_KEY], found_player, message)
  end

  def commit_stats_update_for_player(game_week, stats_hash, found_player, message)
    match_player = found_player.player_for_game_week(game_week)
    update_stats_for_player(match_player, stats_hash)

    points_strategy = PointsStrategy.new(Settings.points_strategy, match_player)
    match_player.points = points_strategy.calculate_points
    match_player.save!

    respond(message, :ok)
  end

  def update_stats_for_player(match_player, stats)
    return if stats.nil?
    all_stats_hash = stats.values.reduce({}) do |acc_hash, value|
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
    message.add_message(
      1,
      'No attributes were provided to identify the player, please specify one of id,' \
      ' name with team, type or both, or team and type'
    )
    respond(message, :unprocessable_entity)
  end

  def add_no_player_error_message_and_respond(message, found_player, player_finder)
    if found_player == :none
      player_finder.add_no_player_found_message(message)
      return respond(message, :not_found)
    elsif found_player == :too_many
      player_finder.add_multiple_players_found_message(message)
      return respond(message, :not_found)
    end
  end
end
