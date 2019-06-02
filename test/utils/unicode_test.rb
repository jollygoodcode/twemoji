require "test_helper"

module Twemoji
  module Utils
    class UnicodeTest < Minitest::Test
      def test_unpack
        result = Twemoji::Utils::Unicode.unpack("🇲🇾")

        assert_equal "1f1f2-1f1fe", result
      end
    end
  end
end
