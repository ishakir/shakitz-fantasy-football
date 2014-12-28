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
end
