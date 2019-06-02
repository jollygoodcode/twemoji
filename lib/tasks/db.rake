# frozen_string_literal: true

require "fileutils"
require "json"

require_relative "../twemoji/db/unicode/emoji_test_parser"

def curl_download(url, output_file)
  puts "Downloading #{url} => #{output_file}"
  directory = File.dirname(output_file)
  FileUtils.mkdir_p(directory) if !File.exist?(directory)
  system "curl", "-fsSL", url, "-o", output_file
end

file EmojiDataFiles.emoji_test_file do |task|
  curl_download(EmojiDataFiles.emoji_test_url, task.name)
end

file EmojiDataFiles.annotations_file do |task|
  curl_download(EmojiDataFiles.annotations_url, task.name)
end

file EmojiDataFiles.annotations_derived_file do |task|
  curl_download(EmojiDataFiles.annotations_derived_url, task.name)
end

namespace :db do
  desc %(Prepare data files needed for generating emojis.json)
  task prepare_files: [
    EmojiDataFiles.emoji_test_file,
    EmojiDataFiles.annotations_file,
    EmojiDataFiles.annotations_derived_file,
  ]

  desc "Generate emojis.json to db folder"
  task dump: :prepare_files do
    emojis = EmojiTestParser.parse

    puts JSON.pretty_generate(emojis)
    puts "Parsed #{emojis.size} emojis from #{EmojiDataFiles.version}!"
  end
end
