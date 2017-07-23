today = Time.zone.today

# If it's tuesday upload for the week before
current_game_week = WithGameWeek.current_game_week
week_number = today.wday == 2 ? current_game_week - 1 : current_game_week
host = 'localhost'
port = Settings.port
year = WithGameWeek.start_of_first_gameweek.year
kind = Settings.season_type
is_valid_game_week = week_number > 0 && (week_number < Settings.number_of_gameweeks + 1)

puts week_number

# If we don't have a valid game week, bail ootherwise lets update the stats
raise "Cannot update stats for week #{week_number} as it doesn't exist!" unless is_valid_game_week

sleep_time = rand(5 * 60)
Rails.logger.info "Sleeping #{sleep_time} seconds before uploading stats"
sleep(sleep_time)

Rails.logger.info "Uploading stats for week #{week_number}"
cmd = 'python python/update_stats.py ' \
      "--host #{host} " \
      "--port #{port} " \
      "--year #{year} " \
      "--kind #{kind} " \
      "--game_week #{week_number}"
Rails.logger.info "Executing '#{cmd}'"
result = `#{cmd}`
Rails.logger.info('Finished uploading stats, stdout was: ')
Rails.logger.info(result)
