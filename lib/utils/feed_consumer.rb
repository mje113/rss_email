require 'feedzirra'
require 'parallel'

class Utils::FeedConsumer

  MAX_THREADS = 10
  USER_AGENT  = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-US) AppleWebKit/533.4 (KHTML, like Gecko) Chrome/5.0.375.99 Safari/533.4'.freeze

  def initialize(consumer = Feedzirra::Feed)
    @consumer = consumer
  end

  def consume(url)
    raw_feed = @consumer.fetch_and_parse(url, user_agent: USER_AGENT)
    Utils::RawFeed.new(raw_feed)
  end

  def batch_consume(urls)
    feeds = Parallel.map(urls, in_threads: max_threads(urls)) { |url|
      consume(url)
    }

    Hash[urls.zip(feeds)]
  end

  private

  def max_threads(feeds)
    feeds.size < MAX_THREADS ? feeds.size : MAX_THREADS
  end
end