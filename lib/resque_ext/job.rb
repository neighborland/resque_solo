module Resque
  class Job
    def perform_solo
      res = nil
      begin
        res = perform_without_solo
      ensure
        ResqueSolo::Queue.mark_unqueued(@queue, self)
      end
      res
    end

    alias_method :perform_without_solo, :perform
    alias_method :perform, :perform_solo

    class << self
      # Mark an item as queued
      def create_solo(queue, klass, *args)
        item = { class: klass.to_s, args: args }
        if Resque.inline? || !ResqueSolo::Queue.is_unique?(item)
          return create_without_solo(queue, klass, *args)
        end
        ResqueSolo::Queue.mark_queued(queue, item) ? create_without_solo(queue, klass, *args) : false
      end

      # Mark destroyed jobs as unqueued
      def destroy_solo(queue, klass, *args)
        ResqueSolo::Queue.destroy(queue, klass, *args) unless Resque.inline?
        destroy_without_solo(queue, klass, *args)
      end

      alias_method :create_without_solo, :create
      alias_method :create, :create_solo
      alias_method :destroy_without_solo, :destroy
      alias_method :destroy, :destroy_solo
    end
  end
end
