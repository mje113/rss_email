require 'feedbag'
require 'parallel'

class FeedFinder

  def find(url, finder = Feedbag, consumer = FeedConsumer.new)
    
    if feed = Feed.find_by_url(url)
      Array(feed) if feed
    else
      Feedbag.find(url).map { |url|
        Feed.new(url: url)
      }
    end
  end

end
