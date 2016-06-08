require "test_helper"

class TwemojiTest < Minitest::Test
  def setup
    @option = {}
  end

  def test_number_of_emojis
    assert_equal 874, Twemoji::CODES.size
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

  def test_find_by_unicode_country_flag
    assert_equal ":es:", Twemoji.find_by_unicode("🇪🇸")
  end

  def test_find_by_escaped_unicode
    assert_equal ":heart_eyes:", Twemoji.find_by_unicode("\u{1f60d}")
  end

  def test_parse_plus_one
    expected = %(<img draggable="false" title=":+1:" alt="👍" src="https://twemoji.maxcdn.com/16x16/1f44d.png" class="emoji">)

    assert_equal expected, Twemoji.parse(":+1:")
  end

  def test_parse_html_string
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://twemoji.maxcdn.com/16x16/1f60d.png" class="emoji">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!")
  end

  def test_parse_document
    doc  = Nokogiri::HTML::DocumentFragment.parse("<p>I like chocolate :heart_eyes:!</p>")
    expected = '<p>I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://twemoji.maxcdn.com/16x16/1f60d.png" class="emoji">!</p>'

    assert_equal expected, Twemoji.parse(doc).to_html
  end

  def test_parse_option_asset_root
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://emoji.bestcdn.com/16x16/1f60d.png" class="emoji">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", asset_root: 'https://emoji.bestcdn.com')
  end

  def test_parse_option_file_ext_svg
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://twemoji.maxcdn.com/svg/1f60d.svg" class="emoji">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", file_ext: '.svg')
  end

  def test_parse_option_unsupport_file_ext_gif
    exception = assert_raises RuntimeError do
      Twemoji.parse("I like chocolate :heart_eyes:!", file_ext: '.gif')
    end

    assert_equal "Unsupported file extension: .gif", exception.message
  end

  def test_parse_option_image_size
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://twemoji.maxcdn.com/72x72/1f60d.png" class="emoji">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", file_ext: ".png", image_size: "72x72")
  end

  def test_parse_option_class_name
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://twemoji.maxcdn.com/16x16/1f60d.png" class="twemoji">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji')
  end

  def test_parse_option_single_img_attr
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://twemoji.maxcdn.com/16x16/1f60d.png" class="twemoji" style="height: 1.3em;">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji', img_attrs: { style: 'height: 1.3em;' })
  end

  def test_parse_option_multiple_img_attrs
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://twemoji.maxcdn.com/16x16/1f60d.png" class="twemoji" style="height: 1.3em;" width="20">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji', img_attrs: { style: 'height: 1.3em;', width: "20" })
  end

  def test_parse_option_img_attr_callable
    shortname_filter = ->(name) { name.gsub(":", "") }

    img_attrs = {
      style: "height: 1.3em;",
      title: shortname_filter,
      alt:   shortname_filter,
    }

    expected = %(I like chocolate <img draggable="false" title="heart_eyes" alt="heart_eyes" src="https://twemoji.maxcdn.com/16x16/1f60d.png" class="twemoji" style="height: 1.3em;">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji', img_attrs: img_attrs)
  end

  def test_emoji_pattern
    assert_kind_of Regexp, Twemoji.emoji_pattern
  end

  def test_to_json_unsupported_file_ext
    assert_raises RuntimeError do
      Twemoji.to_json(file_ext: "bmp")
    end
  end

  def test_to_json_unsupported_png_size
    assert_raises RuntimeError do
      Twemoji.to_json(file_ext: "png", image_size: "24x24")
    end
  end

  def test_to_json_svg_format
    json = assert_nothing_raised do
      Twemoji.to_json(file_ext: "svg")
    end

    refute_includes json, "png"
  end

  def test_to_json_svg_format_ignore_image_size
    json = assert_nothing_raised do
      Twemoji.to_json(file_ext: "svg", image_size: "16x16")
    end

    refute_includes json, "png"
  end

  def test_to_json_png_format_size_16x16
    json = assert_nothing_raised do
      Twemoji.to_json(file_ext: "png", image_size: "16x16")
    end

    refute_includes json, "svg"
  end

  def test_to_json_png_format_size_36x36
    json = assert_nothing_raised do
      Twemoji.to_json(file_ext: "png", image_size: "36x36")
    end

    refute_includes json, "svg"
  end

  def test_to_json_png_format_size_72x72
    json = assert_nothing_raised do
      Twemoji.to_json(file_ext: "png", image_size: "72x72")
    end

    refute_includes json, "svg"
  end
end
