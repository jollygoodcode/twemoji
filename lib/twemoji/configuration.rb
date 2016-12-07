# frozen_string_literal: true

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
    attr_accessor :asset_root, :file_ext, :class_name, :img_attrs

    def initialize
      @asset_root = "https://twemoji.maxcdn.com/2"
      @file_ext   = "svg"
      @class_name = "emoji"
      @img_attrs  = {}
    end
  end
end
