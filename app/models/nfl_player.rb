# -*- encoding : utf-8 -*-
class NflPlayer < ActiveRecord::Base
  include WithGameWeek

  belongs_to :nfl_team
  belongs_to :nfl_player_type

  has_many :match_players
  has_many :inward_waiver_players, class_name: 'WaiverWire', foreign_key: 'player_in_id'
  has_many :outward_waiver_players, class_name: 'WaiverWire', foreign_key: 'player_out_id'
  validates :name,
            presence: true

  validates :nfl_player_type,
            presence: true

  validates :nfl_id,
            uniqueness: { allow_blank: true, allow_nil: true }

  def player_for_game_week(game_week)
    game_week_as_number = game_week.to_i
    for_game_week(match_players, game_week_as_number)
  end

  def player_for_current_game_week
    for_current_game_week(match_players)
  end

  def player_for_current_unlocked_game_week
    for_current_unlocked_game_week(match_players)
  end

  def points
    # This is a functional "fold"
    match_players.reduce(0) do |sum, match_player|
      sum + match_player.points
    end
  end

  def self.players_with_no_team_for_current_game_week
    players_with_team = []
    players_with_no_team = []
    User.all.find_each do |u|
      GameWeekTeam.find_unique_with(u.id, WithGameWeek.current_game_week).match_players.each do |mp|
        players_with_team.push(mp.nfl_player_id)
      end
    end

    NflPlayer.all.find_each do |p|
      unless players_with_team.include? p.id
        clone = p.as_json
        clone['team'] = NflTeam.find(p.nfl_team_id).name
        players_with_no_team.push(clone)
      end
    end
    players_with_no_team
  end
end
