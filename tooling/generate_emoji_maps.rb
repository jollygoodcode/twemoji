require "open-uri"
require "yaml"
require "pp"
require "net/https"
require "async"
require "async/barrier"
require "async/semaphore"
require "async/http/internet"
require "fileutils"
require_relative "./helpers/emoji_name"

ROOT = File.dirname(__FILE__)

# https://unicode.org/Public/emoji/15.0/emoji-test.txt
unicode_emojies = File.read(File.join(ROOT, "emoji-test.txt")).split("\n")

# 2764                                                   ; unqualified         # ❤ E0.6 red heart
# 1FA77                                                  ; fully-qualified     # 🩷 E15.0 pink heart
unicode_emojies.select! { |row| row.include?("; fully-qualified     # ") }

## STEP 1. Extract unicode.org emoji list, merge it with country ISO codes.

emojies = {}
unicode_emojies.each do |row|
  unicode_code = row.split(";").first.strip.downcase.gsub(" ", "-")
  emoji_name = row.split(/E\d{1,2}.\d{1,2}/).last.strip.downcase.gsub(" ", "_")

  if emojies.key?(unicode_code)
    raise "Duplicated unicode code: #{unicode_code}"
  else
    emojies[emoji_name] = unicode_code
  end
end

flag_emojies = YAML.load(File.read(File.join(ROOT, "flags.yml")))

# Important because we'll keep entries like flag_france and flag_fr
emojies = emojies.merge(flag_emojies)

## STEP 2. Remove all unnecessary symbols from emoji names.
# Only letters, numbers and underscores are allowed.

fixed_emojies = {}
emojies.each do |name, unicode|
  fixed_emojies[emoji_name(name)] = unicode
end

## STEP 3. Validating that all emojies adhere to our format.

fixed_emojies.each_with_index do |(name, unicode), index|
  if name !~ /\A[a-z0-9\_]+\z/
    raise "⚠️ #{index}. --> Invalid emoji name: #{name} - #{unicode}"
  else
    puts "✅ #{index}. --> Valid #{name} - #{unicode}"
  end
end

## STEP 4. Now we have a Hash with 3911 items.
# They're original unicode.org emojies – some aren't present in the Twemoji set,
# some are missing on CDN.
#
# Let's validate which emojies are present on CDN and keep only those.

@absent_emoji_names = {}

PARALLELISM = 10

# https://github.com/socketry/async-http#limiting-requests
Async do
	internet = Async::HTTP::Internet.new
	barrier = Async::Barrier.new
	semaphore = Async::Semaphore.new(PARALLELISM, parent: barrier)

  fixed_emojies.each do |emoji_name, unicode|
		semaphore.async do
      slug = unicode.gsub("_", "-")

			request = internet.get("https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/#{slug}.svg")

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

## Step 5. As you can see, we're down from 3911 items to 3661. Not bad!
# Let's remove absent emojies from our Hash.

File.open(File.join(ROOT, "absent_emojies.txt"), "w") do |file|
  file.puts(@absent_emoji_names.sort.to_h.to_yaml)
end

fixed_present_emojies = fixed_emojies.reject { |name| @absent_emoji_names.key?(name) }

puts fixed_emojies.size
puts fixed_present_emojies.size

# Step 6. Finally, let's prepare our data files and we're ready to ship a brand new version.

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
    emoji_unicode_png_hash[":#{name}:"] = "https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/#{slug}.png"
  end

  file.puts emoji_unicode_png_hash.merge(original_hash).sort.to_h.to_yaml
end

File.open(File.join(ROOT, "data", "emoji-unicode-svg.yml"), "w") do |file|
  original_file = File.join(ROOT, "..", "lib", "twemoji", "data", "emoji-unicode-svg.yml")
  original_hash = YAML.load(File.read(original_file))

  emoji_unicode_svg_hash = {}

  fixed_present_emojies.each do |name, unicode|
    slug = unicode.gsub("_", "-")
    emoji_unicode_svg_hash[":#{name}:"] = "https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/#{slug}.svg"
  end

  file.puts emoji_unicode_svg_hash.merge(original_hash).sort.to_h.to_yaml
end

# Step 7. Let's copy data files and the gem is ready to go.

FileUtils.cp_r(
  File.join(ROOT, "data"),
  File.join(ROOT, "..", "lib", "twemoji")
)

puts "DONE, #{fixed_present_emojies.size} emojies so far 🍻"
