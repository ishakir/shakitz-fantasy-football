# -*- encoding : utf-8 -*-
require 'test_helper'
require 'game_week_progresser'

class ProgressGameWeekTest < ActionController::TestCase
  test 'progress_game_week copies all players into next game week team' do
    GameWeekProgresser.new.progress_game_week(1)
    game_week_team = GameWeekTeam.find(19)
    assert_equal 18, game_week_team.match_players.size
  end

  test 'progress_game_week copies the correct players into second game week team' do
    GameWeekProgresser.new.progress_game_week(1)
    game_week_team = GameWeekTeam.find(19)
    assert game_week_team.match_players.include?(MatchPlayer.find(60))
  end

  test 'playing status is maintained' do
    GameWeekProgresser.new.progress_game_week(1)

    game_week_team = GameWeekTeam.find(19)
    match_player = MatchPlayer.find(70)

    game_week_team_player = GameWeekTeamPlayer.where(game_week_team: game_week_team, match_player: match_player).first
    assert game_week_team_player.playing
  end
end
