# frozen_string_literal: true

module Twemoji
  module Utils
    module Unicode
      # Convert raw unicode to string key version.
      #
      # e.g. 🇲🇾 converts to "1f1f2-1f1fe"
      #
      # @param unicode [String] Unicode codepoint.
      # @param connector [String] (optional) connector to join codepoints
      #
      # @return [String] codepoints of unicode join by connector argument, defaults to "-".
      def self.unpack(unicode, connector: "-")
        unicode.split("").map { |r| "%x" % r.ord }.join(connector)
      end
    end
  end
end
