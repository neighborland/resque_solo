if ENV["SIMPLE_COV"]
  require "simplecov"
  SimpleCov.start
end

require "minitest/autorun"
require "minitest/reporters"
require "resque_solo"
require "fake_jobs"
require "fakeredis/minitest"
begin
  require "pry-byebug"
rescue LoadError
  # ignore
end

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new({ color: true })]
