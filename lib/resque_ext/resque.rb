module Resque
  class << self
    # Override
    # https://github.com/resque/resque/blob/master/lib/resque.rb
    def enqueue_to(queue, klass, *args)
      # Perform before_enqueue hooks. Don't perform enqueue if any hook returns false
      before_hooks = Plugin.before_enqueue_hooks(klass).collect do |hook|
        klass.send(hook, *args)
      end
      return nil if before_hooks.any? { |result| result == false }

      result = Job.create(queue, klass, *args)
      return nil if result == "EXISTED"

      Plugin.after_enqueue_hooks(klass).each do |hook|
        klass.send(hook, *args)
      end

      true
    end

    def enqueued?(klass, *args)
      enqueued_in?(queue_from_class(klass), klass, *args)
    end

    def enqueued_in?(queue, klass, *args)
      item = { class: klass.to_s, args: args }
      return nil unless ResqueSolo::Queue.is_unique?(item)
      ResqueSolo::Queue.queued?(queue, item)
    end

    def remove_queue_with_cleanup(queue)
      remove_queue_without_cleanup(queue)
      ResqueSolo::Queue.cleanup(queue)
    end

    alias_method :remove_queue_without_cleanup, :remove_queue
    alias_method :remove_queue, :remove_queue_with_cleanup
  end
end
