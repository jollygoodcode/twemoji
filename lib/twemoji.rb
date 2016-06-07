# frozen_string_literal: true

require "nokogiri"
require "json"
require "twemoji/version"
require "twemoji/map"
require "twemoji/configuration"

# Twemoji is a Ruby implementation, parses your text, replace emoji text
# with corresponding emoji image. Default emoji images are from Twiiter CDN.
module Twemoji
  # Find code by text, find text by code, and find text by unicode.
  #
  # @example Usage
  #   Twemoji.find_by(text: ":heart_eyes:") # => "1f60d"
  #   Twemoji.find_by(code: ":1f60d:")      # => ":heart_eyes:"
  #   Twemoji.find_by(unicode: "😍")        # => ":heart_eyes:"
  #   Twemoji.find_by(unicode: "\u{1f60d}") # => ":heart_eyes:"
  #
  # @option options [String] (optional) :text
  # @option options [String] (optional) :code
  # @option options [String] (optional) :unicode
  #
  # @return [String] Emoji text or code.
  def self.find_by(text: nil, code: nil, unicode: nil)
    if [ text, code, unicode ].compact!.size > 1
      fail ArgumentError, "Can only specify text, code or unicode one at a time"
    end

    case
    when text
      find_by_text text
    when unicode
      find_by_unicode unicode
    else
      find_by_code code
    end
  end

  # Find emoji code by emoji text.
  #
  # @example Usage
  #   Twemoji.find_by_text ":heart_eyes:"
  #   => "1f60d"
  #
  # @param text [String] Text to find emoji code.
  # @return [String] Emoji Code.
  def self.find_by_text(text)
    CODES[must_str(text)]
  end

  # Find emoji text by emoji code.
  #
  # @example Usage
  #   Twemoji.find_by_code "1f60d"
  #   => ":heart_eyes:"
  #
  # @param code [String] Emoji code to find text.
  # @return [String] Emoji Text.
  def self.find_by_code(code)
    ICODES[must_str(code)]
  end

  # Find emoji text by raw emoji unicode.
  #
  # @example Usage
  #   Twemoji.find_by_unicode "😍"
  #   => ":heart_eyes:"
  #
  # @param raw [String] Emoji raw unicode to find text.
  # @return [String] Emoji Text.
  def self.find_by_unicode(raw)
    ICODES[must_str("%4.4x" % raw.ord)]
  end

  # Render raw emoji unicode from emoji text or emoji code.
  #
  # @example Usage
  #   Twemoji.render_unicode ":heart_eyes:"
  #   => "😍"
  #   Twemoji.render_unicode "1f60d"
  #   => "😍"
  #
  # @param text_or_code [String] Emoji text or code to render as unicode.
  # @return [String] Emoji UTF-8 Text.
  def self.render_unicode(text_or_code)
    text_or_code = find_by_text(text_or_code) if text_or_code[0] == ":"
    [text_or_code.hex].pack("U")
  end

  # Parse string, replace emoji text with image.
  # Parse DOM, replace emoji with image.
  #
  # @example Usage
  #   Twemoji.parse("I like chocolate :heart_eyes:!")
  #   => "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/16x16/1f60d.png'>!"
  #
  # @param text [String] Source text to parse.
  #
  # @option options [String] (optional) asset_root Asset root url to serve emoji.
  # @option options [String] (optional) file_ext   File extension.
  # @option options [String] (optional) img_attrs Emoji image's img tag attributes.
  #
  # @return [String] Original text with all occurrences of emoji text
  # replaced by emoji image according to given options.
  def self.parse(text, asset_root: Twemoji.configuration.asset_root,
                       file_ext:   Twemoji.configuration.file_ext,
                       class_name: Twemoji.configuration.class_name,
                       img_attrs:  Twemoji.configuration.img_attrs)

    options[:asset_root] = asset_root
    options[:file_ext]   = file_ext
    options[:img_attrs]  = { class: class_name }.merge! img_attrs

    if text.is_a?(Nokogiri::HTML::DocumentFragment)
      parse_document(text)
    else
      parse_html(text)
    end
  end

  # Return all emoji patterns' regular expressions.
  #
  # @return [RegExp] A Regular expression consists of all emojis text.
  def self.emoji_pattern
    @emoji_pattern ||= /(#{CODES.keys.map { |name| Regexp.quote(name) }.join("|") })/
  end

  private

    # Ensure text is a string.
    #
    # @param text [String] Text to ensure to be a string.
    # @return [String] A String.
    # @private
    def self.must_str(text)
      text.respond_to?(:to_str) ? text.to_str : text.to_s
    end

    # Options hash for Twemoji.
    #
    # @return [Hash] Hash of options.
    # @private
    def self.options
      @options ||= {}
    end

    # Parse a HTML String, replace emoji text with corresponding emoji image.
    #
    # @param text [String] Text string to be parse.
    # @return [String] Text with emoji text replaced by emoji image.
    # @private
    def self.parse_html(text)
      return text if !text.include?(":")

      filter_emojis(text)
    end

    # Parse a Nokogiri::HTML::DocumentFragment document, replace emoji text
    # with corresponding emoji image.
    #
    # @param doc [Nokogiri::HTML::DocumentFragment] Document to parse.
    # @return [Nokogiri::HTML::DocumentFragment] Parsed document.
    # @private
    def self.parse_document(doc)
      doc.xpath('.//text() | text()').each do |node|
        content = node.to_html
        next if !content.include?(":")
        next if has_ancestor?(node, %w(pre code tt))
        html = filter_emojis(content)
        next if html == content
        node.replace(html)
      end
      doc
    end

    # Find out if a node with given exclude tags has ancestors.
    #
    # @param node [Nokogiri::XML::Text] Text node to find ancestor.
    # @param tags [Array] Array of String represents tags.
    # @return [Boolean] If has ancestor returns true, otherwise falsy (nil).
    # @private
    def self.has_ancestor?(node, tags)
      while node = node.parent
        if tags.include?(node.name.downcase)
          break true
        end
      end
    end

    # Filter emoji text in content, replaced by corresponding emoji image.
    #
    # @param content [String] Contetn to filter emoji text to image.
    # @return [String] Returns a String just like content with all emoji text
    #                  replaced by the corresponding emoji image.
    # @private
    def self.filter_emojis(content)
      content.gsub(emoji_pattern) { |match| img_tag(match) }
    end

    # Returns emoji image tag by given name and options from `Twemoji.parse`.
    #
    # @param name [String] Emoji name to generate image tag.
    # @return [String] Emoji image tag generated by name and options.
    # @private
    def self.img_tag(name)
      img_attrs_hash = default_attrs(name).merge! customized_attrs(name)

      %(<img #{hash_to_html_attrs(img_attrs_hash)}>)
    end

    # Returns emoji url by given name and options from `Twemoji.parse`.
    #
    # @param name [String] Emoji name to generate image url.
    # @return [String] Emoji image tag generated by name and options.
    # @private
    def self.emoji_url(name)
      code = find_by_text(name)

      if options[:file_ext] == ".png"
        File.join(options[:asset_root], "72x72", "#{code}.png")
      elsif options[:file_ext] == ".svg"
        File.join(options[:asset_root], "svg", "#{code}.svg")
      else
        fail "Unsupported file extension: #{options[:file_ext]}"
      end
    end

    # Returns user customized img attributes. If attribute value is any proc-like
    # object, will call it and the emoji name will be passed as argument.
    #
    # @param name [String] Emoji name.
    # @return Hash of customized attributes
    # @private
    def self.customized_attrs(name)
      custom_img_attributes = options[:img_attrs]

      # run value filters where given
      custom_img_attributes.each do |key, value|
        custom_img_attributes[key] = value.call(name) if value.respond_to?(:call)
      end
    end

    # Default img attributes: draggable, title, alt, src.
    #
    # @param name [String] Emoji name.
    # @return Hash of default attributes
    # @private
    def self.default_attrs(name)
      {
        draggable: "false".freeze,
        title:     name,
        alt:       render_unicode(name),
        src:       emoji_url(name)
      }
    end

    # Coverts hash of attributes into HTML attributes.
    #
    # @param hash [Hash] Hash of attributes.
    # @return [String] HTML attributes suitable for use in tag
    # @private
    def self.hash_to_html_attrs(hash)
      hash.map { |attr, value| %(#{attr}="#{value}") }.join(" ")
    end
end
