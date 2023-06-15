require "test_helper"

class TwemojiTest < Minitest::Test
  def setup
  end

  def test_number_of_emojis
    assert_equal 4904, Twemoji.codes.size
  end

  def test_twemoji_png_and_svg_not_loaded_by_default
    assert_raises NameError do
      Twemoji::PNG
      Twemoji::SVG
    end
  end

  def test_twemoji_png
    require "twemoji/png"
    assert_raises NameError do
      Twemoji::PNG
    end
    assert_equal 4904, Twemoji.png.size
  end

  def test_twemoji_svg
    require "twemoji/svg"
    assert_raises NameError do
      Twemoji::SVG
    end
    assert_equal 4904, Twemoji.svg.size
  end

  def test_finder_methods_cannot_find_by_more_than_one
    exception = assert_raises ArgumentError do
      Twemoji.find_by(text: ":cookie:", code: "1f36a")
    end

    assert_equal "Can only specify text, code or unicode one at a time", exception.message
  end

  def test_finder_methods_find_by_text
    assert_equal "1f36a", Twemoji.find_by(text: ":cookie:")
  end

  def test_finder_methods_find_by_code
    assert_equal ":cookie:", Twemoji.find_by(code: "1f36a")
  end

  def test_find_by_text_for_emoji_with_multiple_names_v1
    assert_equal "1f60d", Twemoji.find_by_text(":smiling_face_with_heart_eyes:")
  end

  def test_find_by_text_for_emoji_with_multiple_names_v2
    assert_equal "1f60d", Twemoji.find_by_text(":heart_eyes:")
  end

  def test_finder_methods_find_by_unicode
    assert_equal ":cookie:", Twemoji.find_by(unicode: "🍪")
  end

  def test_find_by_text
    assert_equal "1f36a", Twemoji.find_by_text(":cookie:")
  end

  def test_find_by_code
    assert_equal ":cookie:", Twemoji.find_by_code("1f36a")
  end

  def test_find_by_unicode
    assert_equal ":smiling_face_with_heart_eyes:", Twemoji.find_by_unicode("😍")
  end

  def test_find_by_unicode_copyright
    assert_equal ":copyright:", Twemoji.find_by_unicode("©")
  end

  def test_find_by_unicode_country_flag
    assert_equal ":flag_spain:", Twemoji.find_by_unicode("🇪🇸")
  end

  def test_render_unicode_country_flag_es
    assert_equal "🇪🇸", Twemoji.render_unicode(":flag-es:")
  end

  def test_render_unicode_country_flag_es_unicode
    assert_equal "🇪🇸", Twemoji.render_unicode("1f1ea-1f1f8")
  end

  def test_find_by_escaped_unicode
    assert_equal ":smiling_face_with_heart_eyes:", Twemoji.find_by_unicode("\u{1f60d}")
  end

  def test_parse_plus_one
    expected = %(<img draggable="false" title=":+1:" alt="👍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f44d.svg" class="emoji">)

    assert_equal expected, Twemoji.parse(":+1:")
  end

  def test_parse_minus_one
    expected = %(<img draggable="false" title=":-1:" alt="👎" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f44e.svg" class="emoji">)

    assert_equal expected, Twemoji.parse(":-1:")
  end

  def test_parse_html_string
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="emoji">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!")
  end

  def test_parse_document
    doc  = Nokogiri::HTML::DocumentFragment.parse("<p>I like chocolate :heart_eyes:!</p>")
    expected = '<p>I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="emoji">!</p>'

    assert_equal expected, Twemoji.parse(doc).to_html
  end

  def test_parse_option_asset_root
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://emoji.bestcdn.com/svg/1f60d.svg" class="emoji">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", asset_root: 'https://emoji.bestcdn.com')
  end

  def test_parse_option_file_ext_png
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/1f60d.png" class="emoji">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", file_ext: 'png')
  end

  def test_parse_option_unsupport_file_ext_gif
    exception = assert_raises RuntimeError do
      Twemoji.parse("I like chocolate :heart_eyes:!", file_ext: 'gif')
    end

    assert_equal "Unsupported file extension: gif", exception.message
  end

  def test_parse_option_class_name
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="twemoji">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji')
  end

  def test_parse_option_single_img_attr
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="twemoji" style="height: 1.3em;">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji', img_attrs: { style: 'height: 1.3em;' })
  end

  def test_parse_option_multiple_img_attrs
    expected = %(I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="twemoji" style="height: 1.3em;" width="20">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji', img_attrs: { style: 'height: 1.3em;', width: "20" })
  end

  def test_parse_option_img_attr_callable
    shortname_filter = ->(name) { name.gsub(":", "") }

    img_attrs = {
      style: "height: 1.3em;",
      title: shortname_filter,
      alt:   shortname_filter,
    }

    expected = %(I like chocolate <img draggable="false" title="heart_eyes" alt="heart_eyes" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="twemoji" style="height: 1.3em;">!)

    assert_equal expected, Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji', img_attrs: img_attrs)
  end

  def test_parse_diversity_emojis
    DiversityEmoji.all.each do |diversity|
      # Each diversity set of emojis could have either 6 or 11 tags.
      # v3: base + 5 modifier = 6
      # v5: base + 5 modifier + 5 new syntax = 11
      assert_includes [6, 11], Twemoji.parse(diversity).scan(/<img/).size
    end
  end

  def test_parse_flag_img_alt
    expected = %(<img draggable=\"false\" title=\":flag-sg:\" alt=\"🇸🇬\" src=\"https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f1f8-1f1ec.svg\" class=\"emoji\">)

    assert_equal expected, Twemoji.parse(":flag-sg:")
  end

  def test_emoji_pattern
    assert_kind_of Regexp, Twemoji.emoji_pattern
  end

  def test_emoji_unicode
    assert_kind_of Regexp, Twemoji.emoji_pattern_unicode
  end

  def test_emoji_all
    assert_kind_of Regexp, Twemoji.emoji_pattern_all
  end

  def test_parse_by_unicode
    expected = %(<img draggable="false" title=":cookie:" alt="🍪" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f36a.svg" class="emoji">)

    assert_equal expected, Twemoji.parse("🍪")
  end

  def test_parse_by_unicode_flag
    expected = %(<img draggable=\"false\" title=\":flag_my:\" alt=\"🇲🇾\" src=\"https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f1f2-1f1fe.svg\" class=\"emoji\">)

    assert_equal expected, Twemoji.parse("🇲🇾")
  end

  def test_parse_by_unicode_text
    expected = %(I like chocolate <img draggable="false" title=":smiling_face_with_heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="twemoji">!)

    assert_equal expected, Twemoji.parse("I like chocolate 😍!", class_name: 'twemoji')
  end

  def test_parse_by_unicode_attr
    expected = %(<img draggable="false" title=":smiling_face_with_heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="twemoji" aria-label="emoji: smiling_face_with_heart_eyes">)
    aria_label = ->(name) { 'emoji: ' + name.gsub(":", '') }
    assert_equal expected, Twemoji.parse("😍", img_attrs: {'aria-label'=> aria_label }, class_name: 'twemoji' )
  end

  def test_parse_by_unicode_multiple
    expected = %(<img draggable="false" title=":cookie:" alt="🍪" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f36a.svg" class="emoji" aria-label="emoji: cookie"><img draggable="false" title=":birthday_cake:" alt="🎂" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f382.svg" class="emoji" aria-label="emoji: birthday_cake">)
    aria_label = ->(name) { 'emoji: ' + name.gsub(":", '') }
    assert_equal expected, Twemoji.parse("🍪🎂", img_attrs: {'aria-label'=> aria_label } )
  end

  def test_parse_by_unicode_multiple_html
    expected = %(<p><img draggable="false" title=":cookie:" alt="🍪" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f36a.svg" class="emoji" aria-label="emoji: cookie"><img draggable="false" title=":birthday_cake:" alt="🎂" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f382.svg" class="emoji" aria-label="emoji: birthday_cake"></p>)
    aria_label = ->(name) { 'emoji: ' + name.gsub(":", '') }
    assert_equal expected, Twemoji.parse(Nokogiri::HTML::DocumentFragment.parse("<p>🍪🎂</p>"), img_attrs: {'aria-label'=> aria_label } ).to_html
  end

  def test_parse_by_unicode_multiple_mix_codepoint_name_html
    expected = %(<p><img draggable="false" title=":cookie:" alt="🍪" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f36a.svg" class="emoji" aria-label="emoji: cookie"><img draggable="false" title=":birthday:" alt="🎂" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f382.svg" class="emoji" aria-label="emoji: birthday"></p>)
    aria_label = ->(name) { 'emoji: ' + name.gsub(":", '') }
    assert_equal expected, Twemoji.parse(Nokogiri::HTML::DocumentFragment.parse("<p>🍪:birthday:</p>"), img_attrs: {'aria-label'=> aria_label } ).to_html
  end

  def test_parse_by_unicode_and_name
    expected = %(<img draggable="false" title=":cookie:" alt="🍪" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f36a.svg" class="emoji" aria-label="emoji: cookie"><img draggable="false" title=":birthday_cake:" alt="🎂" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f382.svg" class="emoji" aria-label="emoji: birthday_cake">)
    aria_label = ->(name) { 'emoji: ' + name.gsub(":", '') }
    assert_equal expected, Twemoji.parse(":cookie:🎂", img_attrs: {'aria-label'=> aria_label } )
  end

  def test_parse_multiple
    expected = %(<img draggable="false" title=":cookie:" alt="🍪" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f36a.svg" class="emoji" aria-label="emoji: cookie"><img draggable="false" title=":birthday:" alt="🎂" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f382.svg" class="emoji" aria-label="emoji: birthday">)
    aria_label = ->(name) { 'emoji: ' + name.gsub(":", '') }
    assert_equal expected, Twemoji.parse(":cookie::birthday:", img_attrs: {'aria-label'=> aria_label } )
  end

  def test_parse_empty_class_name
    expected = '<img draggable="false" title=":flag_brazil:" alt="🇧🇷" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f1e7-1f1f7.svg">'

    assert_equal expected, Twemoji.parse('🇧🇷', class_name: nil)
    assert_equal expected, Twemoji.parse('🇧🇷', class_name: '')
  end
end
