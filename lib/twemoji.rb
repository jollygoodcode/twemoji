require "nokogiri"

require "twemoji/version"
require "twemoji/map"

module Twemoji
  # Find code by text and find text by code.
  #
  # @example Usage
  #
  #   Twemoji.find_by(text: :heart_eyes:) # => "1f60d"
  #   Twemoji.find_by(code: :1f60d:)      # => "heart_eyes"
  #
  # @option options [String] (optional) :text
  # @option options [String] (optional) :code
  #
  # @return [String] Text or Code
  def self.find_by(*args, text: nil, code: nil)
    raise "Can only specify text or code one at a time" if text && code

    if text
      find_by_text text
    else
      find_by_code code
    end
  end

  # Find emoji code by emoji text
  #
  # @example Usage
  #
  #   Twemoji.find_by_text ":heart_eyes:"
  #   => "1f60d"
  #
  # @param text [String] Text to find emoji code
  #
  # @return [String] Emoji Code
  def self.find_by_text(text)
    CODES[must_str(text)]
  end

  # Find emoji text by emoji code
  #
  # @example Usage
  #
  #   Twemoji.find_by_code "1f60d"
  #   => ":heart_eyes:"
  #
  # @param code [String] Emoji code to find text
  #
  # @return [String] Emoji Text
  def self.find_by_code(code)
    ICODES[must_str(code)]
  end

  # Parse text, replace emoji text with image.
  #
  # @example Usage
  #
  #   Twemoji.parse("I like chocolate :heart_eyes:!")
  #   => => 'I like chololate <img class="emoji" draggable="false" alt=":heart_eyes:" src="https://twemoji.maxcdn.com/svg/1f60d.svg">'
  #
  # @param text [String] source text to parse.
  #
  # @option options [String] (optional) asset_root Asset root url to serve emoji.
  # @option options [String] (optional) asset_path Folder where you store your emoji images.
  # @option options [String] (optional) file_ext   File extension.
  # @option options [String] (optional) image_size Emoji image's size 16, 36, 72 applicable if specify .png.
  # @option options [String] (optional) class_name Emoji image's css class name.
  #
  # @return [String] Original text but the occurrences of emoji text replaced with emoji image by given options.
  def self.parse(text, asset_root: "https://twemoji.maxcdn.com/",
                       asset_path: "",
                       file_ext:   ".svg",
                       image_size: "16x16",
                       class_name: "emoji")

    options[:asset_root] = asset_root
    options[:asset_path] = asset_path
    options[:file_ext]   = file_ext
    options[:image_size] = image_size
    options[:class_name] = class_name

    if text.kind_of?(String)
      parse_html(text)
    else
      parse_document(text)
    end
  end

  # Return all emoji patterns' regexp
  #
  # @return [RegExp] A Regular expression consists of all emojis text.
  def self.emoji_pattern
    @emoji_pattern ||= /(#{CODES.keys.each { |name| Regexp.escape(name) }.join("|") })/
  end

  private
    # Ensure text is string
    #
    # @param text [String]
    #
    # @return [String]
    def self.must_str(text)
      text = text.respond_to?(:to_str) ? text.to_str : text.to_s
    end

    def self.options
      @options ||= {}
    end

    def self.parse_html(text)
      return text if !text.include?(":")

      filter_emojis(text)
    end

    def self.parse_document(doc)
      doc.search('text()').each do |node|
        content = node.to_html
        next if !content.include?(":")
        next if has_ancestor?(node, %w(pre code tt))
        html = filter_emojis(content)
        next if html == content
        node.replace(html)
      end
      doc
    end

    def self.filter_emojis(content)
      content.gsub(emoji_pattern) { |match| img_tag(match) }
    end

    def self.img_tag(name)
      "<img class='#{options[:class_name]}' draggable='false' title='#{name}' alt='#{name}' src='#{emoji_url(name)}'>"
    end

    def self.emoji_url(name)
      code = find_by_text(name)

      if options[:file_ext] == ".svg"
        File.join(options[:asset_root], "svg", "#{code}.svg")
      elsif !options[:asset_path].empty?
        File.join(options[:asset_root], options[:asset_path], "#{code}.#{options[:file_ext]}")
      elsif options[:file_ext] == ".png"
        File.join(options[:asset_root], options[:image_size], "#{code}.png")
      else
        File.join(options[:asset_root], options[:image_size], "#{code}.#{options[:file_ext]}")
      end
    end
end
