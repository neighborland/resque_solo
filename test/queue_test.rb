require "test_helper"

module ResqueSolo
  class QueueTest < MiniTest::Spec
    describe ".is_unique?" do
      it "is false for non-unique job" do
        refute Queue.is_unique?(class: "FakeJob")
      end

      it "is false for invalid job class" do
        refute Queue.is_unique?(class: "InvalidJob")
      end

      it "is true for unique job" do
        assert Queue.is_unique?(class: "FakeUniqueJob")
      end
    end

    describe ".item_ttl" do
      it "is -1 for non-unique job" do
        assert_equal(-1, Queue.item_ttl(class: "FakeJob"))
      end

      it "is -1 for invalid job class" do
        assert_equal(-1, Queue.item_ttl(class: "InvalidJob"))
      end

      it "is -1 for unique job" do
        assert_equal(-1, Queue.item_ttl(class: "FakeUniqueJob"))
      end

      it "is job TTL" do
        assert_equal 300, UniqueJobWithTtl.ttl
        assert_equal 300, Queue.item_ttl(class: "UniqueJobWithTtl")
      end
    end

    describe ".lock_after_execution_period" do
      it "is 0 for non-unique job" do
        assert_equal 0, Queue.lock_after_execution_period(class: "FakeJob")
      end

      it "is 0 for invalid job class" do
        assert_equal 0, Queue.lock_after_execution_period(class: "InvalidJob")
      end

      it "is 0 for unique job" do
        assert_equal 0, Queue.lock_after_execution_period(class: "FakeUniqueJob")
      end

      it "is job lock period" do
        assert_equal 150, UniqueJobWithLock.lock_after_execution_period
        assert_equal 150, Queue.lock_after_execution_period(class: "UniqueJobWithLock")
      end
    end
  end
end
