require 'fixture_generator'

raise 'Attempted to generate fixtures, but fixtures already existed so aborting' unless Fixture.all.empty?

Rails.logger.info 'Generating fixtures'
FixturesGenerator.new.generate
