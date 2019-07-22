# frozen_string_literal: true

class FakeJob
  @queue = :normal
end

class FakeUniqueJob
  include Resque::Plugins::UniqueJob
  @queue = :unique

  def self.perform(_)
  end
end

class FailingUniqueJob
  include Resque::Plugins::UniqueJob
  @queue = :unique

  def self.perform(_)
    raise "Fail"
  end
end

class UniqueJobWithTtl
  include Resque::Plugins::UniqueJob
  @queue = :unique_with_ttl
  @ttl = 300

  def self.perform(*_)
  end
end

class UniqueJobWithLock
  include Resque::Plugins::UniqueJob
  @queue = :unique_with_lock
  @lock_after_execution_period = 150

  def self.perform(*_)
  end
end

class EnqueueFailUniqueJob
  include Resque::Plugins::UniqueJob
  @queue = :unique

  def self.perform(_)
  end

  def self.before_enqueue_fail
    false
  end
end

class EnqueueErrorUniqueJob
  include Resque::Plugins::UniqueJob
  @queue = :unique

  def self.perform(_)
  end

  def self.before_enqueue_zzz_error
    raise "Fail"
  end
end

class DontPerformUniqueJob
  include Resque::Plugins::UniqueJob
  @queue = :unique

  def self.perform(_)
  end

  def self.before_perform_dont
    raise Resque::Job::DontPerform
  end
end

class BeforePerformErrorUniqueJob
  include Resque::Plugins::UniqueJob
  @queue = :unique

  def self.perform(_)
  end

  def self.before_perform_dont
    raise "Fail"
  end
end