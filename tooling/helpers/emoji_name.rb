# This method takes a raw emoji name from the unicode.org
# emoji-test.txt file and converts it to a name that's only
# made of letters, numbers and underscores.
#
# Examples:
# rolling on the floor laughing -> rolling_on_the_floor_laughing
# smiling face with heart-eyes -> smiling_face_with_heart_eyes
# backhand index pointing up: dark skin tone -> backhand_index_pointing_up_dark_skin_tone
# Japanese “here” button -> japanese_here_button
#
def emoji_name(raw_name)
  raw_name
    .gsub("flag:_", "flag_")
    .gsub(/[“”]/, "_")
    .gsub("!", "_")
    .gsub("_(", "_")
    .gsub(/\)\z/, "")
    .gsub(":_", "_")
    .gsub("’", "")
    .gsub(/_[\#\*]\z/, "")
    .gsub(",_", "_")
    .gsub("._", "_")
    .gsub("_&_", "_")
    .gsub("_u.s_", "_us_")
    .gsub("ñ", "n")
    .gsub(")_", "_")
    .gsub("å", "a")
    .gsub("é", "e")
    .gsub("ô", "p")
    .gsub("ç", "c")
    .gsub("ã", "a")
    .gsub("í", "i")
    .gsub("-", "_")
    .gsub(":_", "_")
    .gsub("__", "_")
end
