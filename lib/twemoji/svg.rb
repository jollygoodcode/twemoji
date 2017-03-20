# frozen_string_literal: true

module Twemoji
  def self.svg
    SVG
  end

  SVG = Twemoji.load_yaml(Configuration::SVG_MAP_FILE).freeze
  private_constant :SVG
end
