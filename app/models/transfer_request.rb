# -*- encoding : utf-8 -*-
class TransferRequest < ActiveRecord::Base
  STATUS_PENDING = 'pending'
  STATUS_ACCEPTED = 'accepted'
  STATUS_REJECTED = 'rejected'
  STATUS_CANCELLED = 'cancelled'

  ALLOWED_TYPES = [STATUS_PENDING, STATUS_ACCEPTED, STATUS_REJECTED, STATUS_CANCELLED]

  belongs_to :offering_user,
             foreign_key: :offering_user_id,
             class_name: 'User'

  belongs_to :target_user,
             foreign_key: :target_user_id,
             class_name: 'User'

  belongs_to :trade_back_game_week, class_name: 'GameWeek', foreign_key: 'trade_back_game_week_id'

  has_many :transfer_request_players

  validates :offering_user,
            presence: true

  validates :target_user,
            presence: true

  validate :players_are_balanced_present_and_different
  validate :users_are_different

  validates :status,
            inclusion: { in: ALLOWED_TYPES, allow_nil: false }
            
  # TODO test anything new in this class
  # TODO validate trade back game week?

  def users_are_different
    return unless offering_user.present? && target_user.present?
    offering_user_id = offering_user.id
    target_user_id = target_user.id
    return unless offering_user_id == target_user_id
    errors.add(:users, "Request and target users are the same, with id #{offering_user_id}")
  end

  def players_are_balanced_present_and_different
    if offered_players.size != target_players.size
      errors.add(:players, "Number of offered and requested players must be equal! #{offered_players.size} vs #{target_players.size}")
    end
    offered_players.each do |offered_player|
      if(target_players.include?(offered_player))
        errors.add(:players, "Player #{offered_player} is both offered and targeted!")
      end
    end
  end

  def offered_players
    filter_players(true)
  end

  def target_players
    filter_players(false)
  end

  private

  def filter_players(offered)
    trps = transfer_request_players.select do |trp|
      trp.offered == offered
    end
    trps.map(&:nfl_player)
  end
end
