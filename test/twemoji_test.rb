require "test_helper"

class TwemojiTest < Minitest::Test
  def setup
    @option = {}
  end

  def test_finder_methods_cannot_find_by_more_than_one
    exception = assert_raises ArgumentError do
      Twemoji.find_by(text: ":heart_eyes:", code: "1f60d")
    end

    assert_equal "Can only specify text, code or unicode one at a time", exception.message
  end

  def test_finder_methods_find_by_text
    assert_equal "1f60d", Twemoji.find_by(text: ":heart_eyes:")
  end

  def test_finder_methods_find_by_code
    assert_equal ":heart_eyes:", Twemoji.find_by(code: "1f60d")
  end

  def test_finder_methods_find_by_unicode
    assert_equal ":heart_eyes:", Twemoji.find_by(unicode: "😍")
  end

  def test_find_by_text
    assert_equal "1f60d", Twemoji.find_by_text(":heart_eyes:")
  end

  def test_find_by_code
    assert_equal ":heart_eyes:", Twemoji.find_by_code("1f60d")
  end

  def test_find_by_unicode
    assert_equal ":heart_eyes:", Twemoji.find_by_unicode("😍")
  end

  def test_find_by_escaped_unicode
    assert_equal ":heart_eyes:", Twemoji.find_by_unicode("\u{1f60d}")
  end

  def test_parse_html_string
    expected = "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/16x16/1f60d.png'>!"

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!")
  end

  def test_parse_document
    doc  = Nokogiri::HTML::DocumentFragment.parse("<p>I like chocolate :heart_eyes:!</p>")
    expected = '<p>I like chocolate <img class="emoji" draggable="false" title=":heart_eyes:" alt="😍" src="https://twemoji.maxcdn.com/16x16/1f60d.png">!</p>'

    assert_equal expected, Twemoji.parse(doc).to_html
  end

  def test_parse_option_asset_root
    expected = "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://emoji.bestcdn.com/16x16/1f60d.png'>!"

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", asset_root: 'https://emoji.bestcdn.com')
  end

  def test_parse_option_file_ext_svg
    expected = "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/svg/1f60d.svg'>!"

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", file_ext: '.svg')
  end

  def test_parse_option_unsupport_file_ext_gif
    exception = assert_raises RuntimeError do
      Twemoji.parse("I like chocolate :heart_eyes:!", file_ext: '.gif')
    end

    assert_equal "Unsupported file extension: .gif", exception.message
  end

  def test_parse_option_image_size
    expected = "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/72x72/1f60d.png'>!"

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", file_ext: ".png", image_size: "72x72")
  end

  def test_parse_option_class_name
    expected = "I like chocolate <img class='twemoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/16x16/1f60d.png'>!"

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji')
  end

  def test_parse_option_img_attr
    expected = "I like chocolate <img class='twemoji' draggable='false' title=':heart_eyes:' alt='😍' style='height: 1.3em;' src='https://twemoji.maxcdn.com/16x16/1f60d.png'>!"

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji', img_attr: "style='height: 1.3em;'")
  end

  def test_emoji_pattern
    assert_kind_of Regexp, Twemoji.emoji_pattern
  end
end
