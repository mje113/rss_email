require 'feedzirra'
require 'parallel'

class FeedConsumer

  MAX_THREADS = 10
  USER_AGENT  = 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_4; en-US) AppleWebKit/533.4 (KHTML, like Gecko) Chrome/5.0.375.99 Safari/533.4'.freeze

  def initialize(consumer = Feedzirra::Feed)
    @consumer = consumer
  end

  def consume(feed)
    raw_feed = @consumer.fetch_and_parse(feed.url, user_agent: USER_AGENT)
    RawFeed.new(raw_feed)
  end

  def batch_consume(feeds)
    Parallel.map(feeds, in_threads: max_threads(feeds)) { |feed|
      consume(feed)
    }
  end

  private

  def max_threads(feeds)
    feeds.size < MAX_THREADS ? feeds.size : MAX_THREADS
  end
end