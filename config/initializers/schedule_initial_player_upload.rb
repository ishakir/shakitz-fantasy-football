require 'rufus-scheduler'

if not Rails.env.production?
	Rails.logger.info("Not in production mode, so not scheduling initial player upload")
else
	# If there are already players in the database, then we have already done this, and must be restarting
	# the server because of some error or similar.
	if NflPlayer.all.empty?
		scheduler = Rufus::Scheduler.new
		scheduler.in '1m' do
			Rails.logger.info("No NflPlayers found, so attemping to upload")
			year = Time.now.year
			port = Rails::Server.new.options[:Port]
			result = `python python/create_initial_players.py --host localhost --port #{port} --year #{year}`
			Rails.logger.info("Finished uploading initial players, stdout was:")
			Rails.logger.info(result)
		end
	else
		Rails.logger.info("Identified NflPlayers, so not attempting to upload players")
	end
end