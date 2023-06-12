require "open-uri"
require "yaml"
require "pp"

UNICODE_EMOJI_LIST_URL = "https://unicode.org/Public/emoji/15.0/emoji-test.txt"

emojies = URI.open(UNICODE_EMOJI_LIST_URL).read.split("\n")

# 2764                                                   ; unqualified         # ❤ E0.6 red heart
# 1FA77                                                  ; fully-qualified     # 🩷 E15.0 pink heart
emojies.select! { |row| row.include?("; fully-qualified     # ") }

emojies.each do |row|
  puts row.split(";").first.strip.downcase.gsub(" ", "-")
  puts row.split(/E\d{1,2}.\d{1,2}/).last.strip.downcase.gsub(" ", "_")

  puts
end


## TODO
#
# - [ ] Store country code flags in a separate file
# - [ ] Properly extract country names:
# - [ ] Write specs to ensure emojies contain only letters, numbers, dash and underscore
# - [ ] Validator script to ensure all emojies are present on CDN
#
# flag:_bosnia_&_herzegovina
# flag:_st._barthélemy
# couple_with_heart:_woman,_man,_medium-dark_skin_tone,_dark_skin_tone
