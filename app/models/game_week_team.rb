# -*- encoding : utf-8 -*-
class GameWeekTeam < ActiveRecord::Base
  def self.find_unique_with(user_id, game_week)
    gwt_obj_list = GameWeekTeam.where(user_id: user_id).includes(:game_week).where('game_weeks.number' => game_week)

    # There should only we one of these
    no_of_gwt_objs = gwt_obj_list.size
    if no_of_gwt_objs == 0
      fail ActiveRecord::RecordNotFound, no_record_found_message(user_id, game_week)
    elsif no_of_gwt_objs > 1
      fail IllegalStateError, multiple_records_found_message(no_of_gwt_objs, user_id, game_week)
    end

    # Return what must be the only element
    gwt_obj_list.first
  end

  def self.no_record_found_message(user_id, game_week)
    "Didn't find a record with user_id '#{user_id}' and game week '#{game_week}'"
  end

  def self.multiple_records_found_message(no_found, user_id, game_week)
    "Found #{no_found} game week teams with uid '#{user_id}' and game week '#{game_week}'"
  end

  belongs_to :user
  belongs_to :game_week

  has_many :game_week_team_players
  has_many :match_players, through: :game_week_team_players

  validates :user,
            presence: true,
            uniqueness: { scope: :game_week, if: :both_are_present }

  validates :game_week,
            presence: true

  def both_are_present
    user.present? && game_week.present?
  end

  def match_players_playing
    match_players_by_status(true)
  end

  def match_players_benched
    match_players_by_status(false)
  end

  def match_players_by_status(playing)
    gwt_players = game_week_team_players.select do |gwtp|
      gwtp.playing == playing
    end
    gwt_players.map(&:match_player)
  end

  def fixture
    # "Or" is not implemented yet :/
    fixtures = Fixture.where("home_team_id = #{id} or away_team_id = #{id}")
    return nil if fixtures.empty?
    fail IllegalStateException if fixtures.size > 1
    fixtures[0]
  end

  def opponent
    return nil if fixture.nil?
    fixture.opponent_of(self)
  end

  def head_to_head_result
    return nil if fixture.nil?
    return :won if fixture.won_by?(self)
    return :drawn if fixture.drawn?
    return :lost if fixture.lost_by?(self)
    fail IllegalStateException, "fixture wasn't won, drawn or lost by this team!"
  end

  def points
    # This is a functional "fold"
    match_players_playing.reduce(0) do |sum, player|
      sum + player.points
    end
  end

  def bench_points
    match_players_benched.reduce(0) do |sum, player|
      sum + player.points
    end
  end
end
