module Twemoji
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(configuration)
    @configuration = configuration
  end

  def self.configure
    yield configuration
  end

  class Configuration
    attr_accessor :asset_root, :file_ext, :image_size, :class_name, :img_attrs

    def initialize
      @asset_root = "https://twemoji.maxcdn.com/".freeze
      @file_ext   = ".png".freeze
      @image_size = "16x16".freeze
      @class_name = "emoji".freeze
      @img_attrs  = {}
    end
  end
end
