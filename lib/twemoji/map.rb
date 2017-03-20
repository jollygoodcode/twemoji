# frozen_string_literal: true

require "twemoji/configuration"

module Twemoji
  # Emoji Text to Codepoint mappings.
  #
  # @example Usage
  #   codes[":heart_eyes:"] # => "1f60d"
  #   codes[":notebook_with_decorative_cover:"] # => "1f4d4"
  # @return [Hash<String => String>]
  def self.codes
    CODES
  end

  # Emoji Codepoint to Text mappings. This hash is frozen.
  #
  # @example Usage
  #   invert_codes["1f60d"] # => ":heart_eyes:"
  #   invert_codes["1f4d4"] # => ":notebook_with_decorative_cover:"
  #
  # @return [Hash<String => String>]
  def self.invert_codes
    codes.invert.freeze
  end

  # Emoji Text to Codepoint mapping constant. This hash is frozen.
  # @private
  CODES = Twemoji.load_yaml(Configuration::CODE_MAP_FILE).freeze
  private_constant :CODES
end
