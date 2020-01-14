# frozen_string_literal: true

require "nokogiri"
require_relative "../../utils/unicode"

require_relative "emoji_annotation"
require_relative "emoji_annotations"

module CLDR
  class Annotations
    attr_reader :annotations

    def initialize(annotation, annotation_derived)
      @annotations = parse_files(annotation, annotation_derived)
    end

    private

    def parse_files(annotation, annotation_derived)
      parse_file(annotation) + parse_file(annotation_derived)
    end

    def parse_file(path)
      document = get_document(path)
      parse(document)
    end

    def parse(document)
      result = EmojiAnnotations.new

      document.css("annotations annotation").each do |annotation_node|
        next if annotation_node.attributes.key?("type")

        codepoints = get_codepoints(annotation_node.attributes["cp"].text)
        keywords = annotation_node.text.split(" | ")

        emoji_annotation = EmojiAnnotation.new(
          codepoints: codepoints,
          keywords: keywords,
        )

        result.add(emoji_annotation)
      end

      result
    end

    def get_document(path)
      Nokogiri::XML.parse(IO.read(path))
    end

    def get_codepoints(unicode)
      Twemoji::Utils::Unicode.unpack(unicode, connector: " ").upcase
    end
  end
end
