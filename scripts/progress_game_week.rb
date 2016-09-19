require 'game_week_progresser'

current_gw = WithGameWeek.current_game_week
next_gw = current_gw + 1
have_already_progressed = GameWeekTeamPlayer.all.select do |gwtp|
  gwtp.match_player.game_week.number == next_gw && gwtp.game_week_team.game_week.number == next_gw
end.any?

raise "We appear to have already progressed from #{current_gw} to #{next_gw}, aborting" if have_already_progressed
raise "#{current_gw} or #{next_gw} doesn't exist, aborting" if current_gw < 1 || next_gw > Settings.number_of_gameweeks

GameWeekProgresser.new.progress_game_week(current_gw)
