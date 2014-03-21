class User < ActiveRecord::Base
  
  validates :name, presence: true
  
  has_many :game_week_teams, dependent: :destroy
  
end
