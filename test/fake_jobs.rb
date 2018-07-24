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
