# -*- encoding : utf-8 -*-
class FixturesController < ApplicationController
  GAME_WEEK = :game_week

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
end
