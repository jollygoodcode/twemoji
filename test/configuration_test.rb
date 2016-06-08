require "test_helper"

class TwemojiConfigurationTest < Minitest::Test
  def teardown
    Twemoji.configuration = nil
    Twemoji.configure {}
  end

  def test_configuration_defaults
    assert_equal "https://twemoji.maxcdn.com/2", Twemoji.configuration.asset_root
    assert_equal "svg", Twemoji.configuration.file_ext
    assert_equal "emoji", Twemoji.configuration.class_name
    assert_equal Hash(nil), Twemoji.configuration.img_attrs
  end

  def test_configuration_asset_root
    Twemoji.configure do |config|
      config.asset_root = "https://twemoji.awesomecdn.com/"
    end

    assert_equal "https://twemoji.awesomecdn.com/", Twemoji.configuration.asset_root
  end

  def test_configuration_file_ext
    Twemoji.configure do |config|
      config.file_ext = "png"
    end

    assert_equal "png", Twemoji.configuration.file_ext
  end

  def test_configuration_class_name
    Twemoji.configure do |config|
      config.class_name = "twemoji"
    end

    assert_equal "twemoji", Twemoji.configuration.class_name
  end

  def test_configuration_img_attrs
    Twemoji.configure do |config|
      config.img_attrs = { style: "height: 1.3em" }
    end

    assert_equal Hash(style: "height: 1.3em"), Twemoji.configuration.img_attrs
  end
end
