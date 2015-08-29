require 'fixture_generator'

if Fixture.all.empty?
	Rails.logger.info "Generating fixtures"
	FixturesGenerator.new.generate()
else
	raise 'Attempted to generate fixtures, but fixtures already existed so aborting'
end