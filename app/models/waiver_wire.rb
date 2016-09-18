class WaiverWire < ActiveRecord::Base
  STATUS_PENDING = :pending
  STATUS_ACCEPTED = :accepted
  STATUS_REJECTED = :rejected

  ALLOWED_TYPES = [STATUS_PENDING, STATUS_ACCEPTED, STATUS_REJECTED].freeze

  belongs_to :user
  belongs_to :player_out, class_name: 'NflPlayer'
  belongs_to :player_in, class_name: 'NflPlayer'
  belongs_to :game_week

  validates :user, uniqueness: { scope: [:game_week, :incoming_priority], allow_nil: true }, presence: true
  validates :player_out, presence: true
  validates :player_in, presence: true
  validates :game_week, presence: true
  validates :incoming_priority, presence: true
  validates :status, inclusion: { in: ALLOWED_TYPES, allow_nil: false }

  def self.waiver_list(game_week, priority_function = method(:priority_then_points_comparison))
    # We want to get last week's gameweek to get the correct user order
    previous_game_week = GameWeek.find_by number: (game_week - 1)
    current_game_week = GameWeek.find_by number: game_week

    waiver_list = WaiverWire.where(game_week: current_game_week.id)
    waiver_list.sort_by { |w| priority_function.call(w, previous_game_week) }
  end

  def self.resolve(game_week)
    waivers = waiver_list(game_week)

    waivers.each do |waiver|
      resolve_waiver(waiver, game_week)
    end
  end

  def self.priority_then_points_comparison(waiver, game_week)
    [waiver.incoming_priority, waiver.user.team_for_game_week(game_week.number).points]
  end

  def self.execute_swap(player_team, player_out_match, player_in_match)
    GameWeekTeamPlayer.create!(
      game_week_team: player_team,
      match_player: player_in_match,
      playing: player_out_match.game_week_team_players[0].playing?
    )

    player_team.match_players.delete(player_out_match)
  end

  def self.proceed_with_swap(waiver, player_out_match, player_in_match, game_week)
    Rails.logger.info "Proceeding with swap for #{waiver.user.name}, " \
                        "dropping #{waiver.player_out.name}, " \
                        "picking up #{waiver.player_in.name}"
    player_team = waiver.user.team_for_game_week(game_week)
    execute_swap(player_team, player_out_match, player_in_match)
    waiver.update!(status: WaiverWire::STATUS_ACCEPTED)
  end

  def self.resolve_unprocessable_swap(waiver, player_out_still_in_team, player_in_still_available)
    if !player_out_still_in_team
      Rails.logger.info "Could not execute waiver for #{waiver.user.name} " \
                        "as #{waiver.player_out.name} is no longer in their team"
    elsif !player_in_still_available
      Rails.logger.info "Could not execute waiver for #{waiver.user.name} " \
                        "as #{waiver.player_in.name} has already been taken"
    end
    waiver.update!(status: WaiverWire::STATUS_REJECTED)
  end

  def self.resolve_waiver(waiver, game_week)
    player_out_match = waiver.player_out.player_for_game_week(game_week)
    player_in_match = waiver.player_in.player_for_game_week(game_week)

    player_out_still_in_team = !player_out_match.game_week_team.nil?
    player_in_still_available = player_in_match.game_week_team.nil?

    if player_out_still_in_team && player_in_still_available
      proceed_with_swap(waiver, player_out_match, player_in_match, game_week)
    else
      resolve_unprocessable_swap(waiver, player_out_still_in_team, player_in_still_available)
    end
  end
end
