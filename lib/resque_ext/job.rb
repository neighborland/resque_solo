module Resque
  class Job
    class << self
      # Mark an item as queued
      def create_solo(queue, klass, *args)
        item = { class: klass.to_s, args: args }
        if Resque.inline? || !ResqueSolo::Queue.is_unique?(item)
          return create_without_solo(queue, klass, *args)
        end
        return "EXISTED" if ResqueSolo::Queue.queued?(queue, item)
        create_return_value = false
        # redis transaction block
        Resque.redis.multi do
          create_return_value = create_without_solo(queue, klass, *args)
          ResqueSolo::Queue.mark_queued(queue, item)
        end
        create_return_value
      end

      # Mark an item as unqueued
      def reserve_solo(queue)
        item = reserve_without_solo(queue)
        ResqueSolo::Queue.mark_unqueued(queue, item) if item && !Resque.inline?
        item
      end

      # Mark destroyed jobs as unqueued
      def destroy_solo(queue, klass, *args)
        ResqueSolo::Queue.destroy(queue, klass, *args) unless Resque.inline?
        destroy_without_solo(queue, klass, *args)
      end

      alias_method :create_without_solo, :create
      alias_method :create, :create_solo
      alias_method :reserve_without_solo, :reserve
      alias_method :reserve, :reserve_solo
      alias_method :destroy_without_solo, :destroy
      alias_method :destroy, :destroy_solo

      # Hack to support resque-priority_enqueue: https://github.com/coupa/resque-priority_enqueue
      def priority_create_solo(queue, klass, *args)
        item = { class: klass.to_s, args: args }
        if Resque.inline? || !ResqueSolo::Queue.is_unique?(item)
          return priority_create_without_solo(queue, klass, *args)
        end
        return "EXISTED" if ResqueSolo::Queue.queued?(queue, item)
        priority_create_return_value = false
        # redis transaction block
        Resque.redis.multi do
          priority_create_return_value = priority_create_without_solo(queue, klass, *args)
          ResqueSolo::Queue.mark_queued(queue, item)
        end
        priority_create_return_value
      end

      alias_method :priority_create_without_solo, :priority_create
      alias_method :priority_create, :priority_create_solo
    end
  end
end
