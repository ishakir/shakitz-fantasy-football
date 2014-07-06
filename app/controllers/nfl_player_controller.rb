# -*- encoding : utf-8 -*-
require 'player_finder'
require 'response_message'

class NflPlayerController < ApplicationController
  PLAYER_JSON_KEY = :player
  ID_INFO_KEY     = :id_info
  GAME_WEEK_KEY   = :game_week
  STATS_KEY       = :stats

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

  def update_stats
    # Setup the messages to return
    message = ApplicationController::ResponseMessage.new

    # Check that player json is a thing
    return add_no_id_info_error_message_and_respond(message) unless params_validated?(params)

    id_json = params[PLAYER_JSON_KEY][ID_INFO_KEY]

    player_finder = PlayerFinder.new(id_json)

    if player_finder == :only_team
      message.add_message(2, "Only 'team' was provided to identify the player, please specify one of id, name with team, type or both, or team and type")
      return respond(message, :unprocessable_entity)
    elsif player_finder == :only_type
      message.add_message(3, "Only 'type' was provided to identify the player, please specify one of id, name with team, type or both, or team and type")
      return respond(message, :unprocessable_entity)
    end

    found_player = player_finder.player
    if found_player == :none
      player_finder.add_no_player_found_message(message)
      return respond(message, :not_found)
    elsif found_player == :too_many
      player_finder.add_multiple_players_found_message(message)
      return respond(message, :not_found)
    end

    # If there are any inconsistancies, flag them 
    player_finder.add_inconsistancy_messages(message)
    match_player = found_player.player_for_game_week(params[GAME_WEEK_KEY])
    update_stats(match_player, params[PLAYER_JSON_KEY][STATS_KEY])

    respond(message, :ok)
  end

  def update_stats

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
