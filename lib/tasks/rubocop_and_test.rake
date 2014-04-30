require 'rubocop/rake_task'

desc 'Run tests and rubocop'
task :validate do
  Rake::Task['rubocop'].invoke
  Rake::Task['test'].invoke
end

task :rubocop do
  require 'rubocop'
  cli = Rubocop::CLI.new
  cli.run(%w(--rails --auto-correct))
end