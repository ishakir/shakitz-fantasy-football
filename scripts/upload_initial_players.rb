raise 'Already found players in the database, aborting' unless NflPlayer.all.empty?
Rails.logger.info('Attemping to upload initial players')
cmd = 'python python/create_initial_players.py ' \
      '--host localhost ' \
      "--port #{Settings.port} " \
      "--year #{WithGameWeek.start_of_first_gameweek.year} " \
      "--kind #{Settings.season_type}"
Rails.logger.info "Executing '#{cmd}'"
result = `#{cmd}`
Rails.logger.info('Finished uploading initial players, stdout was:')
Rails.logger.info(result)
