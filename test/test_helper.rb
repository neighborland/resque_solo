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

def perform_one_manually(queue_name)
  Resque::Job.reserve(queue_name).perform
end