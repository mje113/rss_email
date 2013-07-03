require 'feedzirra'
require 'parallel'

class FeedConsumer

  MAX_THREADS = 10

  def consume(feed)

  end

  def batch_consume(feeds)
    Parallel.map(feeds, in_threads: max_threads(feeds)) { |feed|
      consume_feed
    }
  end

  private

  def max_threads(feeds)
    feeds.size < MAX_THREADS ? feeds.size : MAX_THREADS
  end
end