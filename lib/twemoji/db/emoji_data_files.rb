# frozen_string_literal: true

class EmojiDataFiles
  VERSION = "release-35-1"
  VENDOR_DIR = File.expand_path("../../../vendor", __dir__)
  UNICODE_REPO_ROOT = "https://raw.githubusercontent.com/unicode-org/cldr/#{VERSION}"
  REMOTE_EMOJI_TEST_PATH = "tools/java/org/unicode/cldr/util/data/emoji/emoji-test.txt"
  REMOTE_ANNOTATIONS_PATH = "common/annotations/en.xml"
  REMOTE_ANNOTATIONS_DERIVED_PATH = "common/annotationsDerived/en.xml"
  private_constant :VERSION, :VENDOR_DIR, :UNICODE_REPO_ROOT
  private_constant :REMOTE_EMOJI_TEST_PATH, :REMOTE_ANNOTATIONS_PATH, :REMOTE_ANNOTATIONS_DERIVED_PATH

  def self.version
    "CLDR #{VERSION}"
  end

  def self.emoji_test_file
    File.join(VENDOR_DIR, VERSION, "emoji-test.txt")
  end

  def self.annotations_file
    File.join(VENDOR_DIR, VERSION, "annotations/en.xml")
  end

  def self.annotations_derived_file
    File.join(VENDOR_DIR, VERSION, "annotationsDerived/en.xml")
  end

  def self.emoji_test_url
    File.join(UNICODE_REPO_ROOT, REMOTE_EMOJI_TEST_PATH)
  end

  def self.annotations_url
    File.join(UNICODE_REPO_ROOT, REMOTE_ANNOTATIONS_PATH)
  end

  def self.annotations_derived_url
    File.join(UNICODE_REPO_ROOT, REMOTE_ANNOTATIONS_DERIVED_PATH)
  end
end
