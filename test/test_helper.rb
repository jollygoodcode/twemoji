require "bundler/setup"
require "twemoji"
require "minitest/autorun"

module TestHelpers
  # Asserts that two html fragments are equivalent. Attribute order
  # will be ignored.
  def assert_equal_html(expected, actual)
    assert_equal Nokogiri::HTML::DocumentFragment.parse(expected).to_hash,
                 Nokogiri::HTML::DocumentFragment.parse(actual).to_hash
  end
end

Minitest::Test.send(:include, TestHelpers)
