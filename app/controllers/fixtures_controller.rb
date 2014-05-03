# -*- encoding : utf-8 -*-
class FixturesController < ApplicationController
  def generate
    users = User.all.map do |user|
      user.id
    end
    schedule = generate_fixture_schedule(users)
    save_fixture_schedule(schedule)
  end

  def generate_fixture_schedule(users)
    cycle_length = users.size.even? ? users.size - 1 : users.size
    RRSchedule::Schedule.new(
      teams: users,
      rules: [
        RRSchedule::Rule.new(
          wday: 6,
          ps: (0 .. users.size), # We have as many places to play as teams, that means
          gt: ["7:00PM"]         # everyone can fit into "one gameweek"
        )
      ],
      cycles: (17.0 / cycle_length).floor # Enough cycles to fit into < 17 game weeks
    ).generate                                                                # Will need to re-think this if no-users > 8
  end

  def save_fixture_schedule(schedule)
    number_difference = 17 - schedule.rounds[0].size
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
