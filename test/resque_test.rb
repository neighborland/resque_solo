# frozen_string_literal: true

require "test_helper"

class ResqueTest < MiniTest::Spec
  before do
    Resque.redis.redis.flushdb
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

  describe "#enqueue_to" do
    describe "non-unique job" do
      it "should return true if job was enqueued" do
        assert Resque.enqueue_to(:normal, FakeJob)
        assert Resque.enqueue_to(:normal, FakeJob)
      end
    end

    describe "unique job" do
      it "should return true if job was enqueued" do
        assert Resque.enqueue_to(:normal, FakeUniqueJob)
      end

      it "should return nil if job already existed" do
        Resque.enqueue_to(:normal, FakeUniqueJob)
        assert_nil Resque.enqueue_to(:normal, FakeUniqueJob)
      end
    end
  end
end
