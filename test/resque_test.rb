require 'test_helper'

class ResqueTest < Test::Unit::TestCase
  setup do
    Resque.redis.flushall
  end

  should "enqueue normal jobs" do
    Resque.enqueue FakeJob, "x"
    Resque.enqueue FakeJob, "x"
    assert_equal 2, Resque.size(:normal)
  end

  should "not be able to report if a non-unique job was enqueued" do
    assert_nil Resque.enqueued?(FakeJob)
  end

  should "not raise when deleting an empty queue" do
    assert_nothing_raised do
      Resque.remove_queue(:unique)
    end
  end

end