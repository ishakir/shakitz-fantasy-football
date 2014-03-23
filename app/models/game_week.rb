class GameWeek < ActiveRecord::Base
  
  has_many :match_players
  has_many :game_week_teams
  
  validates :number, :presence => true
  validate :number_is_in_correct_range
  
  def number_is_in_correct_range
    return if !number.present?
    if(number < 1 || number > 17)
      errors.add(:number, "is not between 1 and 17 inclusive")
    end
  end
  
end
