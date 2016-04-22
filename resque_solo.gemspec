# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "resque_solo/version"

Gem::Specification.new do |spec|
  spec.name          = "resque_solo"
  spec.version       = ResqueSolo::VERSION
  spec.authors       = ["Tee Parham"]
  spec.email         = %w(tee@neighborland.com)
  spec.description   = "Resque plugin to add unique jobs"
  spec.summary       = "Resque plugin to add unique jobs"
  spec.homepage      = "https://github.com/neighborland/resque_solo"
  spec.license       = "MIT"

  spec.files         = Dir["LICENSE.txt", "README.md", "lib/**/*"]
  spec.require_paths = %w(lib)

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency "resque", "~> 1.25"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "fakeredis", "~> 0.4"
  spec.add_development_dependency "minitest", "~> 5.3"
  spec.add_development_dependency "rake", "~> 10.1"
end
