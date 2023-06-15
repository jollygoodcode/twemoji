require "open-uri"
require "yaml"
require "pp"
require "net/https"
require "async"
require "async/barrier"
require "async/semaphore"
require "async/http/internet"
require "fileutils"
require_relative "./helpers/load_emoji_definitions"
require_relative "../lib/twemoji/configuration"

ROOT = File.dirname(__FILE__)

## STEP 1. Load emoji definitions from unicode.org and flags.yml.

emojies = load_emoji_definitions()

## STEP 2. Now we have a Hash with 3911 items.
# They're original unicode.org emojies – some aren't present in the Twemoji set,
# some are missing on CDN.
#
# Let's validate which emojies are present on CDN and keep only those.

@absent_emoji_names = {}

PARALLELISM = 20

# https://github.com/socketry/async-http#limiting-requests
Async do
	internet = Async::HTTP::Internet.new
	barrier = Async::Barrier.new
	semaphore = Async::Semaphore.new(PARALLELISM, parent: barrier)

  emojies.each do |emoji_name, unicode|
		semaphore.async do
      slug = unicode.gsub("_", "-")

			request = internet.get("#{Twemoji::Configuration::DEFAULT_ASSET_ROOT}/svg/#{slug}.svg")

      request.read # if we don't read, connections won't be closed

      if request.status != 200
        puts "⚠️ --> Emoji is absent: #{unicode} #{emoji_name}"

        @absent_emoji_names[emoji_name] = unicode
      end
		end
	end

	barrier.wait
ensure
	internet&.close
end

## Step 3. As you can see, we're down from 3911 items to 3661. Not bad!
# Let's remove absent emojies from our Hash.

File.open(File.join(ROOT, "absent_emojies.txt"), "w") do |file|
  file.puts(@absent_emoji_names.sort.to_h.to_yaml)
end

fixed_present_emojies = emojies.reject { |name| @absent_emoji_names.key?(name) }

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
