# frozen_string_literal: true

class EmojiAnnotations
  attr_reader :annotations

  def initialize(annotations = [])
    @annotations = annotations
  end

  def +(emoji_annotations)
    self.class.new(
      self.annotations + emoji_annotations.annotations
    )
  end

  def add(annotation)
    @annotations << annotation
  end

  def find_by(codepoints:)
    annotations.find { |annotation| codepoints == annotation.codepoints }
  end
end
