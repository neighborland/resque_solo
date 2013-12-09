# ResqueSolo

[![Gem Version](https://badge.fury.io/rb/resque_solo.png)][gem]
[![Build Status](https://api.travis-ci.org/neighborland/resque_solo.png)][build]

[gem]: http://badge.fury.io/rb/resque_solo
[build]: https://travis-ci.org/neighborland/resque_solo

ResqueSolo is a resque plugin to add unique jobs to resque.

It is a re-write of [resque-loner](https://github.com/jayniz/resque-loner).

It requires resque 1.25 and works with ruby 1.9.3 and later.

It removes the dependency on `Resque::Helpers`, which is deprecated for resque 2.0.

## Install

Add the gem to your Gemfile:

    gem 'resque_solo'

## Usage

```ruby
class UpdateCat
  include Resque::Plugins::UniqueJob
  @queue = :cats

  def self.perform(cat_id)
    # do something
  end
end
```

If you attempt to queue a unique job multiple times, it is ignored:

```
Resque.enqueue UpdateCat, 1
=> "OK"
Resque.enqueue UpdateCat, 1
=> "EXISTED"
Resque.enqueue UpdateCat, 1
=> "EXISTED"
Resque.size :cats
=> 1
Resque.enqueued? UpdateCat, 1
=> true
Resque.enqueued_in? :dogs, UpdateCat, 1
=> false
```
