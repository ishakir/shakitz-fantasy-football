require 'game_week_progresser'

current_gw = WithGameWeek.current_game_week
next_gw = current_gw + 1
have_already_progressed = GameWeekTeamPlayer.all.select do |gwtp|
  gwtp.match_player.game_week.number == next_gw && gwtp.game_week_team.game_week.number == next_gw
end.empty?

if have_already_progressed
  fail "We appear to have already progressed from #{current_gw} to #{next_gw}, aborting"
elsif current_gw > 0 && current_gw < Settings.number_of_gameweeks
  fail "We can't progress from game week #{current_gw} to #{next_gw} as one of them doesn't exist, aborting"
else
  GameWeekProgresser.new.progress_game_week(current_gw)
end
