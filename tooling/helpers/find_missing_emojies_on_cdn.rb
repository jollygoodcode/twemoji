require "async"
require "async/barrier"
require "async/semaphore"
require "async/http/internet"
require_relative "../../lib/twemoji/configuration"

PARALLELISM = 20

def find_missing_emojies_on_cdn(emojies)
  absent_emoji_names = {}

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

          absent_emoji_names[emoji_name] = unicode
        end
      end
    end

    barrier.wait
  ensure
    internet&.close
  end

  absent_emoji_names
end
