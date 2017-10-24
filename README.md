# ResqueSolo

[![Gem Version](http://img.shields.io/gem/v/resque_solo.svg)][gem]
[![Build Status](http://img.shields.io/travis/neighborland/resque_solo.svg)][build]

[gem]: http://rubygems.org/gems/resque_solo
[build]: https://travis-ci.org/neighborland/resque_solo

ResqueSolo is a resque plugin to add unique jobs to resque.

It is a re-write of [resque-loner](https://github.com/jayniz/resque-loner).

It requires resque 1.25 and works with ruby 2.0 and later.

It removes the dependency on `Resque::Helpers`, which is deprecated for resque 2.0.

## Install

Add the gem to your Gemfile:

```ruby
gem 'resque_solo'
```

## Usage

```ruby
class UpdateCat
  include Resque::Plugins::UniqueJob
  @queue = :cats
  @lock_after_execution_period = 20

  def self.perform(cat_id)
    # do something
  end
end
```

If you attempt to queue a unique job multiple times, it is ignored:

```
Resque.enqueue UpdateCat, 1
=> true
Resque.enqueue UpdateCat, 1
=> nil
Resque.enqueue UpdateCat, 1
=> nil
Resque.size :cats
=> 1
Resque.enqueued? UpdateCat, 1
=> true
Resque.enqueued_in? :dogs, UpdateCat, 1
=> false
```

### Options

#### `lock_after_execution_period`

By default, lock_after_execution_period is 0 and `enqueued?` becomes false as soon as the job
is being worked on.

The `lock_after_execution_period` setting can be used to delay when the unique job key is deleted
(i.e. when `enqueued?` becomes `false`). For example, if you have a long-running unique job that
takes around 10 seconds, and you don't want to requeue another job until you are sure it is done,
you could set `lock_after_execution_period = 20`. Or if you never want to run a long running
job more than once per minute, set `lock_after_execution_period = 60`.

```ruby
class UpdateCat
  include Resque::Plugins::UniqueJob
  @queue = :cats
  @lock_after_execution_period = 20

  def self.perform(cat_id)
    # do something
  end
end
```
