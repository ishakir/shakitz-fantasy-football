# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base
  include WithGameWeek
  include PlayerNameModule

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
  has_many :comments

  def self.authenticate(name, password)
    user = find_by_name(name)
    return user if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
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
    opponents = game_week_teams.map(&:opponent)
    opponents.compact
  end

  def all_results(*game_week_number)
    game_week_number = game_week_number.empty? ? last_game_week : game_week_number.first
    no_results = { wins: 0, draws: 0, losses: 0 }
    return no_results if game_week_number.zero?

    teams_up_to_game_week(game_week_number).each_with_object(no_results) do |game_week_team, hash|
      update_results_hash(game_week_team, hash)
    end
  end

  def team_for_current_game_week
    for_current_game_week(game_week_teams)
  end

  def team_for_current_unlocked_game_week
    for_current_unlocked_game_week(game_week_teams)
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

  def bench_points
    game_week_teams.reduce(0) do |sum, game_week_team|
      sum + game_week_team.bench_points
    end
  end

  private

  def last_game_week
    WithGameWeek.current_game_week - 1
  end

  def update_results_hash(game_week_team, hash)
    result = game_week_team.head_to_head_result
    hash[:wins] += 1 if result == :won
    hash[:draws] += 1 if result == :drawn
    hash[:losses] += 1 if result == :lost
    hash
  end
end
