# -*- encoding : utf-8 -*-
class TransferRequest < ActiveRecord::Base
  STATUS_PENDING = :pending
  STATUS_ACCEPTED = :accepted
  STATUS_REJECTED = :rejected

  ALLOWED_TYPES = [STATUS_PENDING, STATUS_ACCEPTED, STATUS_REJECTED].freeze

  belongs_to :offering_user,
             foreign_key: :offering_user_id,
             class_name: 'User'

  belongs_to :target_user,
             foreign_key: :target_user_id,
             class_name: 'User'

  belongs_to :offered_player,
             foreign_key: :offered_player_id,
             class_name: 'NflPlayer'

  belongs_to :target_player,
             foreign_key: :target_player_id,
             class_name: 'NflPlayer'

  validates :offering_user,
            presence: true

  validates :target_user,
            presence: true

  validates :offered_player,
            presence: true

  validates :target_player,
            presence: true

  validate :users_are_different
  validate :players_are_different

  validates :status,
            inclusion: { in: ALLOWED_TYPES, allow_nil: false }

  def users_are_different
    return unless offering_user.present? && target_user.present?
    offering_user_id = offering_user.id
    target_user_id = target_user.id
    return unless offering_user_id == target_user_id
    errors.add(:users, "Request and target users are the same, with id #{offering_user_id}")
  end

  def players_are_different
    return unless offered_player.present? && target_player.present?
    offered_player_id = offered_player.id
    target_player_id = target_player.id
    return unless offered_player_id == target_player_id
    errors.add(:players, "Offered and Target players are the same, with id #{offered_player_id}")
  end
end
