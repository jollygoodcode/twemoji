# frozen_string_literal: true

class EmojiAnnotation
  attr_reader :codepoints, :keywords

  def initialize(codepoints:, keywords:)
    @codepoints = codepoints
    @keywords = keywords
  end
end
