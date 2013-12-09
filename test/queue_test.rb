require 'test_helper'

class QueueTest < Test::Unit::TestCase
  context ".is_unique?" do
    should "be false for non-unique job" do
      refute ResqueSolo::Queue.is_unique?(class: 'FakeJob')
    end

    should "be false for invalid job class" do
      refute ResqueSolo::Queue.is_unique?(class: 'InvalidJob')
    end

    should "be true for unique job" do
      assert ResqueSolo::Queue.is_unique?(class: 'FakeUniqueJob')
    end
  end
end