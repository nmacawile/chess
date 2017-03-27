require 'rspec/core/rake_task'

task :default => :spec

desc "Launch chess"
task :play do
	ruby "lib/main.rb"
end

desc "Run all tests"
RSpec::Core::RakeTask.new(:spec) do |t|
	t.rspec_opts = "-c"
	t.verbose = false
end