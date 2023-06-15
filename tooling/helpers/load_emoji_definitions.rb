require "open-uri"
require_relative "./emoji_name"

# Just in case: there's a copy of this file as of June 2023 in this folder.
UNICODE_ORG_EMOJI_LIST_URL = "https://unicode.org/Public/emoji/15.0/emoji-test.txt"
HELPERS_FOLDER = File.dirname(__FILE__)

def load_emoji_definitions
  raw_unicode_emojies = URI.open(UNICODE_ORG_EMOJI_LIST_URL).read.split("\n")

  # 2764                                                   ; unqualified         # ❤ E0.6 red heart
  # 1FA77                                                  ; fully-qualified     # 🩷 E15.0 pink heart
  raw_unicode_emojies.select! { |row| row.include?("; fully-qualified     # ") }

  ## STEP 1. Extract unicode.org emoji list, merge it with country ISO codes.

  emojies = {}

  raw_unicode_emojies.each do |row|
    unicode_code = row.split(";").first.strip.downcase.gsub(" ", "-")
    emoji_name = row.split(/E\d{1,2}.\d{1,2}/).last.strip.downcase.gsub(" ", "_")

    if emojies.key?(unicode_code)
      raise "Duplicated unicode code: #{unicode_code}"
    else
      emojies[emoji_name] = unicode_code
    end
  end

  # Here we merge legacy flag emoji keys (like flag-fr) to the mix
  # to ensure backward compatibility.
  flag_emojies = YAML.load(File.read(File.join(HELPERS_FOLDER, "flags.yml")))
  emojies.merge!(flag_emojies)

  # Finally, let's remove all unnecessary symbols from emoji names.
  # Only letters, numbers and underscores are allowed.
  final_emojies = {}

  emojies.each do |name, unicode|
    final_emojies[emoji_name(name)] = unicode
  end

  final_emojies
end
