# frozen_string_literal: true

class EmojiCategory
  attr_reader :name, :type, :emojis

  def initialize(name, type:, emojis: [])
    @name = name
    @type = type
    @emojis = emojis
  end

  def add(emoji)
    @emojis << emoji
  end

  def inspect
    "#<EmojiCategory type: #{@type}, name: #{@name}, emojis: #{@emojis.size} #<Emoji> objects>"
  end
end
