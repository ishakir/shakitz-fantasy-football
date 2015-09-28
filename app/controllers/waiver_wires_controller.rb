class WaiverWiresController < ApplicationController
  include PlayerNameModule

  USER_KEY = :user
  PLAYER_IN_KEY = :player_in
  PLAYER_OUT_KEY = :player_out
  GAME_WEEK_KEY = :game_week
  PRIORITY_KEY = :incoming_priority

  def add
    fail ArgumentError, 'Incorrect post submitted' unless params.key?(:request)
    @priority_array = {} # ensure we don't get duplicate incoming priority values by storing it all in a hash
    if params['request'].present?
      process_requested_waiver_wire_request_additions(params['request'])
      remove_existing_requests_for_user
      add_requests_to_database
    else
      WaiverWire.where(user_id: session[:user_id]).destroy_all
    end
    render json: { response: 'Success' }
  end

  def show
    @users = User.all
    @game_week = WithGameWeek.current_game_week
    @game_week_time_obj = { locked: GameWeek.find_unique_with(@game_week).waiver_locked? }
    @waiver_requests = grab_existing_requests_for_user(session[:user_id])
    @waiver_history = grab_waiver_history
    @nfl_players = NflPlayer.players_with_no_team_for_current_game_week
  end

  def grab_waiver_history
    requests = []
    if @game_week_time_obj[:locked]
      sql = 'game_week_id <= ?'
    else
      sql = 'game_week_id < ?'
    end

    WaiverWire.where(sql, GameWeek.find_unique_with(@game_week)).each do |w|
      requests.push(outgoing: NflPlayer.find(w.player_out_id).name,
                    incoming: NflPlayer.find(w.player_in_id).name,
                    user: User.find(w.user_id).name,
                    game_week: GameWeek.find(w.game_week_id).number)
    end
    requests
  end

  def grab_existing_requests_for_user(user)
    requests = []
    unless @game_week_time_obj[:locked]
      next_game_week = WithGameWeek.current_game_week
      WaiverWire.where(user_id: user, game_week_id: GameWeek.find_unique_with(next_game_week)).each do |w|
        requests.push(priority: w.incoming_priority,
                      outgoing: NflPlayer.find(w.player_out_id).name,
                      outgoingId: w.player_out_id,
                      incoming: NflPlayer.find(w.player_in_id).name,
                      incomingId: w.player_in_id)
      end
    end
    requests.sort_by { |r| r[:priority] }
  end

  def process_requested_waiver_wire_request_additions(requests)
    requests.each do |p|
      validate_waiver_wire_params(p)
      key = p[:incoming_priority]
      @priority_array[key.to_s.to_sym] = p
    end
  end

  def add_requests_to_database
    @priority_array.each do |_k, v|
      WaiverWire.create!(
        user: User.find(v[USER_KEY].to_i),
        player_out: NflPlayer.find(v[PLAYER_OUT_KEY].to_i),
        player_in: NflPlayer.find(v[PLAYER_IN_KEY].to_i),
        game_week: GameWeek.find_by_number(v[GAME_WEEK_KEY].to_i),
        incoming_priority: v[PRIORITY_KEY].to_i
      )
    end
  end

  def remove_existing_requests_for_user
    @priority_array.each do |_k, v|
      if WaiverWire.where(user_id: v[USER_KEY].to_i, game_week_id: v[GAME_WEEK_KEY].to_i, incoming_priority: v[PRIORITY_KEY].to_i).present?
        WaiverWire.destroy_all(user_id: v[USER_KEY].to_i, game_week_id: v[GAME_WEEK_KEY].to_i)
      end
    end
  end

  def validate_waiver_wire_params(params)
    validate_all_parameters([USER_KEY, PLAYER_IN_KEY, PLAYER_OUT_KEY, GAME_WEEK_KEY, PRIORITY_KEY], params)
    validate_user(params[USER_KEY])
    validate_players(params[PLAYER_IN_KEY], params[PLAYER_OUT_KEY])
    validate_game_week(params[GAME_WEEK_KEY].to_i)
    validate_incoming_priority(params[PRIORITY_KEY].to_i)
  end

  def validate_user(user)
    fail ArgumentError, 'User does not exist' unless User.find(user)
  end

  def validate_players(incoming_player, outgoing_player)
    fail ArgumentError, 'Player ids cannot be identical' unless incoming_player != outgoing_player
    fail ArgumentError, 'Incoming player does not exist' unless NflPlayer.find(incoming_player)
    fail ArgumentError, 'Outgoing player does not exist' unless NflPlayer.find(outgoing_player)
  end

  def validate_game_week(game_week)
    fail ArgumentError, 'Gameweek needs to be active gameweek' unless game_week == WithGameWeek.current_game_week
  end

  def validate_incoming_priority(priority)
    fail ArgumentError, 'Incoming priority needs to be a valid number from one onwards' unless priority > 0
  end
end
