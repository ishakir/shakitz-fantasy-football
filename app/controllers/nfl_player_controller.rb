# -*- encoding : utf-8 -*-
class NflPlayerController < ApplicationController
  PLAYER_JSON_KEY = :player

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

    found_all_parameters = nil
    response_code = nil

    begin
      validate_all_parameters([PLAYER_JSON_KEY], params)
      found_all_parameters = validate_id_info(params[PLAYER_JSON_KEY], message)
    rescue ArgumentError
      message.add_message(1, "No attributes were provided to identify the player, please specify one of id, name with team, type or both, or team and type.")
    end

    puts "Found all parameters"

    # If we didn't recieve a player finder, then
    if found_all_parameters
      updated_player = find_and_update_player(params[PLAYER_JSON_KEY], message)
      if updated_player
        response_code = :success
      else
        response_code = :not_found
      end
    else
      response_code = :unprocessable_entity
    end

    puts "Updated player and response code #{response_code}"

    # Render message as JSON
    respond_to do |format|
      format.json { render json: message, status: response_code }
    end
  end

  def validate_id_info(player, message)
    id_info = player['id_info']

    throw ArgumentError, "No attributes supplied!" if id_info.nil? || id_info.empty?

    id_supplied   = id_info['id']
    name_supplied = id_info['name']
    team_supplied = id_info['team']
    type_supplied = id_info['type']

    only_type_supplied = type_supplied && !id_supplied && !team_supplied && !name_supplied
    if only_type_supplied
      message.add_message(2, "Only 'type' was provided to identify the player, please specify one of id, name with team, type or both, or team and type.")
      return false
    end

    only_team_supplied = team_supplied && !id_supplied && !type_supplied && !name_supplied
    if only_team_supplied
      message.add_message(3,  "Only 'team' was provided to identify the player, please specify one of id, name with team, type or both, or team and type.")
      return false
    end

    true
  end

  def find_and_update_player(player, message)
    id_info = player['id_info']
    player_model = find_player(id_info, message)
    if player_model
      check_attributes(id_info, player_model, message)
      update_player(player, player_model, message)
      true
    else
      false
    end
  end

  def find_player(id_info, message)
    id = id_info['id']
    if id
      begin
        return NflPlayer.find(id)
      rescue ActiveRecord::RecordNotFound
        message.add_message(11, "No player was found with id '#{id}'")
        false
      end
    else
      find_player_by_attributes(id_info, message)
    end
  end

  def find_player_by_attributes(id_info, message)
    name = id_info['name']
    team = id_info['team']
    type = id_info['type']

    players = nil

    if name
      players = NflPlayer.where(name: name)
    else
      players = NflPlayer.all
    end

    if players.empty?
      message.add_message()
    if players.size == 1
      return players.first
    end

    if team
      players = players.select do |nfl_player|

      end
    end
  end

  def update_player(player, player_model, message)

  end

  def check_attributes(id_info, player_model, message)

  end
end
