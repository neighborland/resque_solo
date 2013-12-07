module Resque
  class << self
    def enqueued?(klass, *args)
      enqueued_in?(queue_from_class(klass), klass, *args )
    end

    def enqueued_in?(queue, klass, *args)
      item = {class: klass.to_s, args: args}
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
