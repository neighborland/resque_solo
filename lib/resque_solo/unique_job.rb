# frozen_string_literal: true

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

        def before_enqueue_solo_job(*args)
          # This returns false if the key was already set
          !ResqueSolo::Queue.queued?(@queue, { class: self.to_s, args: args })
        end
      end
    end
  end
end
