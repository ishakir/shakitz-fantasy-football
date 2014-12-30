class WaiverWiresController < ApplicationController
  USER_KEY = :user
  PLAYER_IN_KEY = :player_in
  PLAYER_OUT_KEY = :player_out
  GAME_WEEK_KEY = :game_week
  PRIORITY_KEY = :incoming_priority

  def add
    fail ArgumentError, 'Incorrect post submitted' unless params.key?(:request)
    @priority_array = {} # ensure we don't get duplicate incoming priority values by storing it all in a hash
    process_requested_waiver_wire_request_additions(params['request'])
    add_requests_to_database
  end

  def process_requested_waiver_wire_request_additions(requests)
    requests.each do |p|
      validate_waiver_wire_params(p)
      key = p[:incoming_priority]
      @priority_array[key.to_sym] = p
    end
  end

  def add_requests_to_database
    @priority_array.each do |_k, v|
      WaiverWire.create!(
        user: User.find(v[USER_KEY].to_i),
        player_out: NflPlayer.find(v[PLAYER_OUT_KEY].to_i),
        player_in: NflPlayer.find(v[PLAYER_IN_KEY].to_i),
        game_week: GameWeek.find(v[GAME_WEEK_KEY].to_i),
        incoming_priority: v[PRIORITY_KEY].to_i
      )
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
