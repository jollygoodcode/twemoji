require "bundler/setup"
require "twemoji"
require "minitest/autorun"

module Twemoji
  module TestExtensions
    def assert_nothing_raised
      yield if block_given?
    end
  end
end

class Minitest::Test
  include Twemoji::TestExtensions
end
