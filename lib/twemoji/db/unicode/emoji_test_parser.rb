# frozen_string_literal: true

require_relative "emoji_category"
require_relative "emoji"
require_relative "../cldr/annotations"
require_relative "../emoji_data_files"

class EmojiTestParser
  def self.parse(file = EmojiDataFiles.emoji_test_file)
    new(file).parse
  end

  def initialize(file)
    @file = file
  end

  def parse
    emoji_categories = []
    group = nil
    subgroup = nil

    IO.readlines(file).each do |line|
      case
      when line.start_with?("# group: ")
        group = parse_group(line)
        emoji_categories << group
      when line.start_with?("# subgroup: ")
        subgroup = parse_subgroup(line)
        group.add(subgroup)
      when comment?(line) || newline?(line)
        next
      else
        emoji = parse_emoji(line)
        subgroup.add(emoji)
      end
    end

    flatten(emoji_categories)
  end

  private
  attr_reader :file

  def parse_name(line)
    _, name = line.split(":", 2)
    name.strip
  end

  def parse_group(line)
    group_name = parse_name(line)
    EmojiCategory.new(group_name, type: "group")
  end

  def parse_subgroup(line)
    group_name = parse_name(line)
    EmojiCategory.new(group_name, type: "subgroup")
  end

  def comment?(line)
    line.start_with?("#")
  end

  def newline?(line)
    line.strip.empty?
  end

  EMOJI_LINE_REGEXP = /(?<codepoints>.+);(?<status>.+)# (?<unicode>[^[\s]]+)\s(?<description>.+)/
  private_constant :EMOJI_LINE_REGEXP

  def parse_emoji(line)
    matched = line.match(EMOJI_LINE_REGEXP)
    Emoji.new(matched)
  end

  def flatten(data)
    emojis = []

    data.each do |emoji_category|
      emoji_category.emojis.each do |emoji_subcategory|
        emoji_subcategory.emojis.each do |raw_emoji|
          annotation = get_annotation(raw_emoji.codepoints)

          emoji = raw_emoji.to_h(
            group: emoji_category.name,
            subgroup: emoji_subcategory.name,
            keywords: annotation.keywords,
          )

          emojis << emoji
        end
      end
    end

    emojis
  end

  class NullAnnotation
    def keywords; []; end
  end

  def get_annotation(codepoints)
    cldr_annotations.find_by(codepoints: codepoints) || NullAnnotation.new
  end

  def cldr_annotations
    @cldr_annotations ||= begin
      CLDR::Annotations.new(
        EmojiDataFiles.annotations_file,
        EmojiDataFiles.annotations_derived_file,
      ).annotations
    end
  end
end
