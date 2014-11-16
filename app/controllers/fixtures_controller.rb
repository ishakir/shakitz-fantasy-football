# -*- encoding : utf-8 -*-
class FixturesController < ApplicationController
  NUMBER_OF_GAMEWEEKS = Settings.number_of_gameweeks
  GAME_WEEK = :game_week

  def generate
    users = User.all.map(&:id)
    schedule = generate_fixture_schedule(users)
    save_fixture_schedule(schedule)
  end

  def fixtures_for_week
    validate_all_parameters([GAME_WEEK], params)

    list = all_fixtures_for_week(params[GAME_WEEK]).map do |fixture|
      fixture_model_to_resource(fixture)
    end

    render json: list.to_json
  end

  private

  def fixture_model_to_resource(fixture)
    {
      home_team_id: fixture.home_team.id,
      home_name: fixture.home_team.user.team_name,
      away_team_id: fixture.away_team.id,
      away_name: fixture.away_team.user.team_name
    }
  end

  def all_fixtures_for_week(game_week)
    Fixture.joins(home_team: :game_week).where(game_weeks: { number: game_week })
  end

  def generate_fixture_schedule(users)
    cycle_length = users.size.even? ? users.size - 1 : users.size
    RRSchedule::Schedule.new(
      teams: users,
      rules: get_rules(users.size),
      cycles: (NUMBER_OF_GAMEWEEKS / cycle_length).floor # Enough cycles to fit into < NUMBER_OF_GAMEWEEKS game weeks
    ).generate                                           # Will need to re-think this if no-users > 8
  end

  def get_rules(no_users)
    [
      RRSchedule::Rule.new(
        wday: 6,
        ps: (0..no_users), # We have as many places to play as teams, that means
        gt: ['7:00PM']     # everyone can fit into "one gameweek"
      )
    ]
  end

  def save_fixture_schedule(schedule)
    number_difference = NUMBER_OF_GAMEWEEKS - schedule.rounds[0].size
    schedule.rounds[0].each.with_index(1) do |round, i|
      save_game_week_round(round, i + number_difference)
    end
  end

  def save_game_week_round(round, game_week)
    round.games.each do |game|
      next if game.team_a == :dummy || game.team_b == :dummy # i.e. the other team has a bye

      user_a = User.find(game.team_a)
      user_b = User.find(game.team_b)

      team_a = user_a.team_for_game_week(game_week)
      team_b = user_b.team_for_game_week(game_week)

      Fixture.create!(home_team: team_a, away_team: team_b)
    end
  end
end
