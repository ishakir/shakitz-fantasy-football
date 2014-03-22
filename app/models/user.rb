class User < ActiveRecord::Base
  
  validates :name, presence: true
  validates :team_name, presence: true
  
  has_many :game_week_teams, dependent: :destroy
  
end
