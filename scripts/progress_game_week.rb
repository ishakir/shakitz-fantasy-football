require 'game_week_progresser'

current_game_week = WithGameWeek.current_game_week
next_game_week = current_game_week + 1
have_already_progressed = GameWeekTeamPlayer.all.select do |gwtp|
  gwtp.match_player.game_week.number == next_game_week && gwtp.game_week_team.game_week.number == next_game_week
end.empty?

if have_already_progressed
  raise "We appear to have already progressed from #{current_game_week} to #{next_game_week}, aborting"
elsif current_game_week > 0 and current_game_week < Settings.number_of_gameweeks
  raise "We can't progress from game week #{current_game_week} to #{next_game_week} as one of them doesn't exist, aborting"
else
  GameWeekProgresser.new.progress_game_week(current_game_week)
end