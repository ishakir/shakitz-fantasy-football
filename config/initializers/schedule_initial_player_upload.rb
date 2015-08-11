require 'shakitz_scheduler'

if not Settings.schedule or File.basename($0) == "rake"
	Rails.logger.info("Not in production mode, so not scheduling initial player upload")
else
	# If there are already players in the database, then we have already done this, and must be restarting
	# the server because of some error or similar.
	if NflPlayer.all.empty?
		year = WithGameWeek.start_of_first_gameweek.year
		port = Settings.port
		kind = Settings.season_type
		
		ShakitzScheduler.new.in '1m', "initial player upload" do
			Rails.logger.info("Attemping to upload initial players")
			result = `python python/create_initial_players.py --host localhost --port #{port} --year #{year} --kind #{kind}`
			Rails.logger.info("Finished uploading initial players, stdout was:")
			Rails.logger.info(result)
		end
	else
		Rails.logger.info("Identified NflPlayers, so not attempting to upload players")
	end
end