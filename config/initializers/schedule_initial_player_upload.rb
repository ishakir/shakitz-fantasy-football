require 'rufus-scheduler'

if not Settings.schedule or File.basename($0) == "rake"
	Rails.logger.info("Not in production mode, so not scheduling initial player upload")
else
	# If there are already players in the database, then we have already done this, and must be restarting
	# the server because of some error or similar.
	if NflPlayer.all.empty?
		Rails.logger.info "Found no NFLPlayers in the database, so will attempt initial player upload"
		scheduler = Rufus::Scheduler.new
		scheduler.in '1m' do
			Rails.logger.info("Attemping to upload initial players")
			year = WithGameWeek.start_of_first_gameweek.year
			port = Rails::Server.new.options[:Port]
			kind = Settings.season_type
			result = `python python/create_initial_players.py --host localhost --port #{port} --year #{year} --kind #{kind}`
			Rails.logger.info("Finished uploading initial players, stdout was:")
			Rails.logger.info(result)
		end
	else
		Rails.logger.info("Identified NflPlayers, so not attempting to upload players")
	end
end