# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  include WithGameWeek

  attr_accessor :password
  before_save :encrypt_password

  validates :name,
            presence: true,
            uniqueness: true

  validates :team_name,
            presence: true

  validate :password,
           confirmation: true,
           presence: { on: create }

  has_many :game_week_teams, dependent: :destroy

  def self.authenticate(name, password)
    user = find_by_name(name)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    return unless password.present?
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

  def create
    User.create(user_params)
  end

  def user_params
    params.require(:user).permit(:name, :team_name, :password, :password_confirmation)
  end

  def opponents
    opponents = game_week_teams.map do |game_week_team|
      game_week_team.opponent
    end
    opponents.compact
  end

  def won_up_to_game_week(*game_week_number)
    all_results_of_type(:won, game_week_number)
  end

  def drawn_up_to_game_week(*game_week_number)
    all_results_of_type(:drawn, game_week_number)
  end

  def lost_up_to_game_week(*game_week_number)
    all_results_of_type(:lost, game_week_number)
  end

  def team_for_current_game_week
    for_current_game_week(game_week_teams)
  end

  def teams_up_to_game_week(game_week_number)
    up_to_game_week(game_week_teams, game_week_number)
  end

  def team_for_game_week(game_week)
    game_week_as_number = game_week.to_i
    for_game_week(game_week_teams, game_week_as_number)
  end

  def points
    # This is a functional "fold"
    game_week_teams.reduce(0) do |sum, game_week_team|
      sum + game_week_team.points
    end
  end

  private

  def last_game_week
    WithGameWeek.current_game_week - 1
  end

  def all_results_of_type(result_type, game_week_number_array)
    game_week_number = game_week_number_array.empty? ? last_game_week : game_week_number_array.first
    return 0 if game_week_number == 0
    losses = teams_up_to_game_week(game_week_number).select do |game_week_team|
      game_week_team.head_to_head_result == result_type
    end
    losses.size
  end
end
