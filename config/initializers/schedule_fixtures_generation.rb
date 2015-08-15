require 'shakitz_scheduler'
require 'fixture_generator'

if not Settings.schedule or File.basename($0) == "rake"
	Rails.logger.info "Not in production mode, so not scheduling fixtures generation"
else
	if Fixture.all.empty?
		# Schedule fixtures generation for the Tuesday morning before the first game
		generation_time = WithGameWeek.start_of_first_gameweek + 2.days
		ShakitzScheduler.new.at generation_time, "fixtures generation" do
			Rails.logger.info "Running fixtures generation"
			FixturesGenerator.new.generate
		end
	else
		Rails.logger.info "Already found fixtures, so not generating"
	end
end
