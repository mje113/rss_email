require 'feedbag'

class FeedFinder

  def find(url, finder = Feedbag, consumer = FeedConsumer.new)
    feed = Feed.find_by_url(url)
    return Array(feed) if feed

    urls_from_feedbag(url).map { |url|
      Feed.new(url: url)
    }
  end

  def urls_from_feedbag(url)
    Feedbag.find(url)
  end
end
