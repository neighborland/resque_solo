require 'test_helper'

class ResqueTest < MiniTest::Spec
  before do
    Resque.redis.flushall
  end

  it "is a valid plugin" do
    Resque::Plugin.lint(Resque::Plugins::UniqueJob)
  end

  it "enqueues normal jobs" do
    Resque.enqueue FakeJob, "x"
    Resque.enqueue FakeJob, "x"
    assert_equal 2, Resque.size(:normal)
  end

  it "is not able to report if a non-unique job was enqueued" do
    assert_nil Resque.enqueued?(FakeJob)
  end

  it "does not raise when deleting an empty queue" do
    Resque.remove_queue(:unique)
  end
end
