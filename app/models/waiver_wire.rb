class WaiverWire < ActiveRecord::Base
  belongs_to :user
  belongs_to :player_out, class_name: 'NflPlayer'
  belongs_to :player_in, class_name: 'NflPlayer'
  belongs_to :game_week

  validates :user, uniqueness: { scope: [:game_week, :incoming_priority], allow_nil: true }, presence: true
  validates :player_out, presence: true
  validates :player_in, presence: true
  validates :game_week, presence: true
  validates :incoming_priority, presence: true

  def self.waiver_list
    waiver_list = []
    gw = GameWeek.find_by number: WithGameWeek.current_game_week
    WaiverWire.where(game_week: gw.id).find_each do |waiver| # loop over all waiver wire requests
      # find matching user id, and get points
      GameWeek.get_all_points_for_gameweek(WithGameWeek.current_game_week).each do |order|
        next if order[:user_id] != waiver.user_id
        tmp_waiver = waiver.attributes # copy attributes
        tmp_waiver['points'] = order[:points].to_s # append points to new object
        waiver_list.push(tmp_waiver)
      end
    end
    waiver_list
  end

  def self.resolve
    waiver = waiver_list

    transferred_list = [] # keep memory of who has been added
    waiver.each do |w|
      player_out_match = MatchPlayer.find_by nfl_player_id: w['player_out_id'].to_i, game_week_id: w['game_week_id'].to_i
      player_in_match = MatchPlayer.find_by nfl_player_id: w['player_in_id'].to_i, game_week_id: w['game_week_id'].to_i
      # Don't re-add players, or execute if incoming player doesn't exist.
      if transferred_list.include?(w['player_in_id'].to_i) ||
         transferred_list.include?(w['player_out_id'].to_i) || player_in_match.nil?
        WaiverWire.find(w['id']).destroy # Waiver won't get executed, lets destroy it
        next
      end
      Rails.logger.info "Swapping out #{player_out_match.id} for #{player_in_match.id}"
      player_out = player_out_match.game_week_team_players
      Rails.logger.info "Outgoing player has gwtp: #{player_out}"
      player_team = User.find(w['user_id']).team_for_current_game_week
      is_playing = player_out[0].playing?

      GameWeekTeamPlayer.create!(
        game_week_team: player_team,
        match_player: player_in_match,
        playing: is_playing
      )
      transferred_list.push(w['player_in_id'].to_i)
      transferred_list.push(w['player_out_id'].to_i)
      player_team.match_players.delete(player_out_match) # delete player from game week team
    end
  end
end
