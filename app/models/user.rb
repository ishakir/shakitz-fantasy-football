class User < ActiveRecord::Base
  validates :name, presence: true
  validates :team_name, presence: true

  has_many :game_week_teams, dependent: :destroy

  def points
    # This is a functional "fold"
    game_week_teams.reduce(0) do |sum, game_week_team|
      sum + game_week_team.points
    end
  end
end
