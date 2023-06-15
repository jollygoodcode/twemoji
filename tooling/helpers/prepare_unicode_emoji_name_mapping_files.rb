HELPERS_FOLDER = File.dirname(__FILE__)
LIB_FOLDER = File.join(HELPERS_FOLDER, "..", "..", "lib")

def prepare_unicode_emoji_name_mapping_files(emojies)
  unless Dir.exist?(File.join(HELPERS_FOLDER, "data"))
    Dir.mkdir(File.join(HELPERS_FOLDER, "data"))
  end

  File.open(File.join(HELPERS_FOLDER, "data", "emoji-unicode.yml"), "w") do |file|
    original_file = File.join(LIB_FOLDER, "twemoji", "data", "emoji-unicode.yml")
    original_hash = YAML.load(File.read(original_file))

    emoji_unicode_hash = {}

    emojies.each do |name, unicode|
      emoji_unicode_hash[":#{name}:"] = unicode
    end

    file.puts emoji_unicode_hash.merge(original_hash).sort.to_h.to_yaml
  end

  File.open(File.join(HELPERS_FOLDER, "data", "emoji-unicode-png.yml"), "w") do |file|
    original_file = File.join(LIB_FOLDER, "twemoji", "data", "emoji-unicode-png.yml")
    original_hash = YAML.load(File.read(original_file))

    emoji_unicode_png_hash = {}

    emojies.each do |name, unicode|
      slug = unicode.gsub("_", "-")
      emoji_unicode_png_hash[":#{name}:"] = "#{Twemoji::Configuration::DEFAULT_ASSET_ROOT}/72x72/#{slug}.png"
    end

    file.puts emoji_unicode_png_hash.merge(original_hash).sort.to_h.to_yaml
  end

  File.open(File.join(HELPERS_FOLDER, "data", "emoji-unicode-svg.yml"), "w") do |file|
    original_file = File.join(LIB_FOLDER, "twemoji", "data", "emoji-unicode-svg.yml")
    original_hash = YAML.load(File.read(original_file))

    emoji_unicode_svg_hash = {}

    emojies.each do |name, unicode|
      slug = unicode.gsub("_", "-")
      emoji_unicode_svg_hash[":#{name}:"] = "#{Twemoji::Configuration::DEFAULT_ASSET_ROOT}/svg/#{slug}.svg"
    end

    file.puts emoji_unicode_svg_hash.merge(original_hash).sort.to_h.to_yaml
  end

  FileUtils.cp_r(
    File.join(HELPERS_FOLDER, "data"),
    File.join(LIB_FOLDER, "twemoji")
  )
end
