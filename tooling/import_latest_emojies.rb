require "open-uri"
require "yaml"
require "pp"
require "net/https"
require "fileutils"
require_relative "./helpers/load_emoji_definitions"
require_relative "./helpers/find_missing_emojies_on_cdn"
require_relative "./helpers/prepare_unicode_emoji_name_mapping_files"
require_relative "../lib/twemoji/configuration"

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

# STEP 3.
# As you can see, we're down from 3911 items to 3661. Not bad!
# Let's remove absent emojies from our Hash.

puts "\n--> All emojies in the set: #{emojies.size}"

emojies.reject! { |name| absent_emoji_names.key?(name) }

puts "--> All emojies in the set that are present on CDN: #{emojies.size}\n"

# STEP 4.
# Finally, let's prepare our unicode-emoji name mapping files
# and copy them to the gem's data folder.

prepare_unicode_emoji_name_mapping_files(emojies)
