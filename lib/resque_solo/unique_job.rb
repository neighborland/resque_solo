require "digest/md5"

module Resque
  module Plugins
    module UniqueJob
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # Payload is what Resque stored for this job along with the job's class name:
        # a hash containing :class and :args
        def redis_key(payload)
          payload = Resque.decode(Resque.encode(payload))
          job  = payload["class"]
          args = payload["args"]
          args.map! do |arg|
            arg.is_a?(Hash) ? arg.sort : arg
          end

          Digest::MD5.hexdigest Resque.encode(class: job, args: args)
        end

        # The default ttl of a locking key is -1 (forever).
        # To expire the lock after a certain amount of time, set a ttl (in seconds).
        # For example:
        #
        # class FooJob
        #   include Resque::Plugins::UniqueJob
        #   @ttl = 40
        # end
        def ttl
          @ttl ||= -1
        end

        # The default ttl of a persisting key is 0, i.e. immediately deleted.
        # Set lock_after_execution_period to block the execution
        # of the job for a certain amount of time (in seconds).
        # For example:
        #
        # class FooJob
        #   include Resque::Plugins::UniqueJob
        #   @lock_after_execution_period = 40
        # end
        def lock_after_execution_period
          @lock_after_execution_period ||= 0
        end

        # We want this to run first in before_enqueue_hooks (which are alpha sorted), so name appropriately
        def before_enqueue_001_solo_job(*args)
          queue_name, item = get_queue_and_item(*args)
          # This returns false if the key was already set
          ResqueSolo::Queue.mark_queued(queue_name, item)
        end

        # Always marks unqueued, even on failure
        def around_perform_solo_job(*args)
          queue_name, item = get_queue_and_item(*args)
          begin
            yield
          ensure
            ResqueSolo::Queue.mark_unqueued(queue_name, item)
          end
        end

        def get_queue_and_item(*args)
          [self.instance_variable_get(:@queue), { class: self.to_s, args: args }]
        end

      end
    end
  end
end
