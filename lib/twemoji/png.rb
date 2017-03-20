# frozen_string_literal: true

module Twemoji
  def self.png
    PNG
  end

  PNG = Twemoji.load_yaml(Configuration::PNG_MAP_FILE).freeze
  private_constant :PNG
end
