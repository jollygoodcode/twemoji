require "open-uri"
require "yaml"
require "pp"
require "net/https"
require "fileutils"
require_relative "./helpers/load_emoji_definitions"
require_relative "./helpers/find_missing_emojies_on_cdn"
require_relative "../lib/twemoji/configuration"

ROOT = File.dirname(__FILE__)

# STEP 1.
# Load emoji definitions from unicode.org and flags.yml,
# fix emoji names and validate them.

emojies = load_emoji_definitions()

# STEP 2.
# Now we have a Hash with 3911 items.
# They're all original unicode.org emojies.
#
# Problem 1: Some aren't present in the Twemoji set,
# Problem 2: Some are missing on CDN.
#
# Let's validate which emojies are present on CDN and keep only those.

absent_emoji_names = find_missing_emojies_on_cdn(emojies)

## Step 3. As you can see, we're down from 3911 items to 3661. Not bad!
# Let's remove absent emojies from our Hash.

fixed_present_emojies = emojies.reject { |name| absent_emoji_names.key?(name) }

puts emojies.size
puts fixed_present_emojies.size

# Step 4. Finally, let's prepare our data files and we're ready to ship a brand new version.

unless Dir.exist?(File.join(ROOT, "data"))
  Dir.mkdir(File.join(ROOT, "data"))
end

File.open(File.join(ROOT, "data", "emoji-unicode.yml"), "w") do |file|
  original_file = File.join(ROOT, "..", "lib", "twemoji", "data", "emoji-unicode.yml")
  original_hash = YAML.load(File.read(original_file))

  emoji_unicode_hash = {}

  fixed_present_emojies.each do |name, unicode|
    emoji_unicode_hash[":#{name}:"] = unicode
  end

  file.puts emoji_unicode_hash.merge(original_hash).sort.to_h.to_yaml
end

File.open(File.join(ROOT, "data", "emoji-unicode-png.yml"), "w") do |file|
  original_file = File.join(ROOT, "..", "lib", "twemoji", "data", "emoji-unicode-png.yml")
  original_hash = YAML.load(File.read(original_file))

  emoji_unicode_png_hash = {}

  fixed_present_emojies.each do |name, unicode|
    slug = unicode.gsub("_", "-")
    emoji_unicode_png_hash[":#{name}:"] = "#{Twemoji::Configuration::DEFAULT_ASSET_ROOT}/72x72/#{slug}.png"
  end

  file.puts emoji_unicode_png_hash.merge(original_hash).sort.to_h.to_yaml
end

File.open(File.join(ROOT, "data", "emoji-unicode-svg.yml"), "w") do |file|
  original_file = File.join(ROOT, "..", "lib", "twemoji", "data", "emoji-unicode-svg.yml")
  original_hash = YAML.load(File.read(original_file))

  emoji_unicode_svg_hash = {}

  fixed_present_emojies.each do |name, unicode|
    slug = unicode.gsub("_", "-")
    emoji_unicode_svg_hash[":#{name}:"] = "#{Twemoji::Configuration::DEFAULT_ASSET_ROOT}/svg/#{slug}.svg"
  end

  file.puts emoji_unicode_svg_hash.merge(original_hash).sort.to_h.to_yaml
end

# Step 5. Let's copy data files and the gem is ready to go.

FileUtils.cp_r(
  File.join(ROOT, "data"),
  File.join(ROOT, "..", "lib", "twemoji")
)

puts "DONE, #{fixed_present_emojies.size} emojies so far 🍻"
