require 'test_helper'

module ResqueSolo
  class QueueTest < Test::Unit::TestCase
    context ".is_unique?" do
      should "be false for non-unique job" do
        refute Queue.is_unique?(class: 'FakeJob')
      end
  
      should "be false for invalid job class" do
        refute Queue.is_unique?(class: 'InvalidJob')
      end
  
      should "be true for unique job" do
        assert Queue.is_unique?(class: 'FakeUniqueJob')
      end
    end
    
    context ".item_ttl" do
      should "be -1 for non-unique job" do
        assert_equal -1, Queue.item_ttl(class: 'FakeJob')
      end

      should "be -1 for invalid job class" do
        assert_equal -1, Queue.item_ttl(class: 'InvalidJob')
      end

      should "be -1 for unique job" do
        assert_equal -1, Queue.item_ttl(class: 'FakeUniqueJob')
      end

      should "be job TTL" do
        assert_equal 300, UniqueJobWithTtl.ttl
        assert_equal UniqueJobWithTtl.ttl, Queue.item_ttl(class: 'UniqueJobWithTtl')
      end
    end
  end
end
