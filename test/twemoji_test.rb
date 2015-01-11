require "test_helper"

class TwemojiTest < Minitest::Test
  def setup
    @option = {}
  end

  def test_find_by_text
    assert_equal "1f60d", Twemoji.find_by_text(":heart_eyes:")
  end

  def test_find_by_code
    assert_equal ":heart_eyes:", Twemoji.find_by_code("1f60d")
  end

  def test_finder_methods_find_by_text
    assert_equal "1f60d", Twemoji.find_by(text: ":heart_eyes:")
  end

  def test_finder_methods_find_by_code
    assert_equal ":heart_eyes:", Twemoji.find_by(code: "1f60d")
  end

  def test_emoji_pattern
    assert_kind_of Regexp, Twemoji.emoji_pattern
  end

  def test_parse
    expected = "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt=':heart_eyes:' src='https://twemoji.maxcdn.com/svg/1f60d.svg'>!"

    assert_equal expected, Twemoji.parse('I like chocolate :heart_eyes:!')
  end

  def test_parse_with_different_cdn
    expected = "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt=':heart_eyes:' src='https://emoji.bestcdn.com/svg/1f60d.svg'>!"

    assert_equal expected, Twemoji.parse('I like chocolate :heart_eyes:!', asset_root: 'https://emoji.bestcdn.com')
  end
end
