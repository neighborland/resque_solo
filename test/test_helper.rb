require 'test/unit'
require 'shoulda-context'
require 'mocha/setup'
require 'resque_solo'
require 'fake_jobs'
require 'fakeredis'
require 'pry'
begin
  require 'pry-byebug'
rescue LoadError
  # ignore
end
