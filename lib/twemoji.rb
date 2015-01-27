require "nokogiri"

require "twemoji/version"
require "twemoji/map"

# Twemoji is a Ruby implementation, parses your text, replace emoji text
# with corresponding emoji image. Default emoji images are from Twiiter CDN.
module Twemoji
  # Find code by text and find text by code.
  #
  # @example Usage
  #   Twemoji.find_by(text: :heart_eyes:) # => "1f60d"
  #   Twemoji.find_by(code: :1f60d:)      # => ":heart_eyes:"
  #
  # @option options [String] (optional) :text
  # @option options [String] (optional) :code
  #
  # @return [String] Text or Code.
  def self.find_by(text: nil, code: nil)
    if text && code
      fail ArgumentError, "Can only specify text or code one at a time"
    end

    if text
      find_by_text text
    else
      find_by_code code
    end
  end

  # Find emoji code by emoji text
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

  # Parse text, replace emoji text with image.
  #
  # @example Usage
  #   Twemoji.parse("I like chocolate :heart_eyes:!")
  #   => => 'I like chololate <img class="emoji" draggable="false" alt=":heart_eyes:" src="https://twemoji.maxcdn.com/svg/1f60d.svg">'
  #
  # @param text [String] Source text to parse.
  #
  # @option options [String] (optional) asset_root Asset root url to serve emoji.
  # @option options [String] (optional) file_ext   File extension.
  # @option options [String] (optional) image_size Emoji image's size 16, 36, 72 applicable if specify .png.
  # @option options [String] (optional) class_name Emoji image's css class name.
  # @option options [String] (optional) img_attr Emoji image's img tag attribute.
  #
  # @return [String] Original text with all occurrences of emoji text
  # replaced by emoji image according to given options.
  def self.parse(text, asset_root: "https://twemoji.maxcdn.com/",
                       file_ext:   ".png",
                       image_size: "16x16",
                       class_name: "emoji",
                       img_attr: nil)

    options[:asset_root] = asset_root
    options[:file_ext]   = file_ext
    options[:image_size] = image_size
    options[:class_name] = class_name
    options[:img_attr]   = img_attr

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
    @emoji_pattern ||= /(#{CODES.keys.each { |name| Regexp.escape(name) }.join("|") })/
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
      if options[:img_attr]
        "<img class='#{options[:class_name]}' draggable='false' title='#{name}' alt='#{name}' #{options[:img_attr]} src='#{emoji_url(name)}'>"
      else
        "<img class='#{options[:class_name]}' draggable='false' title='#{name}' alt='#{name}' src='#{emoji_url(name)}'>"
      end
    end

    # Returns emoji url by given name and options from `Twemoji.parse`.
    #
    # @param name [String] Emoji name to generate image url.
    # @return [String] Emoji image tag generated by name and options.
    # @private
    def self.emoji_url(name)
      code = find_by_text(name)

      if options[:file_ext] == ".png"
        File.join(options[:asset_root], options[:image_size], "#{code}.png")
      elsif options[:file_ext] == ".svg"
        File.join(options[:asset_root], "svg", "#{code}.svg")
      else
        fail "Unspported file extension: #{options[:file_ext]}"
      end
    end
end
