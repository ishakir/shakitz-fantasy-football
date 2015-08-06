require 'rufus-scheduler'
require 'fixture_generator'

def format_for_rufus(time)
	time.strftime('%Y/%m/%d %H:%M:%S')
end

if not Settings.schedule or File.basename($0) == "rake"
	Rails.logger.info "Not in production mode, so not scheduling fixtures generation"
else
	if Fixture.all.empty?
		# Schedule fixtures generation for the Tuesday morning before the first game
		generation_time = WithGameWeek.start_of_first_gameweek + 2.days
		rufus_time = format_for_rufus(generation_time)
		Rails.logger.info "In production mode, so scheduling fixtures generation for #{rufus_time}"
		Rufus::Scheduler.new.at rufus_time do
			FixtureGenerator.new.generate
		end
	else
		Rails.logger.info "Already found fixtures, so not generating"
	end
end