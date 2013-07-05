class Feed < ActiveRecord::Base

  has_many :stories, -> { order 'published DESC' }
  has_many :subscriptions

  validates :url, presence: true, uniqueness: true

  # delete unsubscribed feeds
  def self.cleanup!
  end

  def self.add(url, finder = FeedFinder.new)
    if feed = Feed.find_by_url(url)
      Array(feed)
    else
      finder.find(url).map { |url|
        Feed.create(url: url)
      }.select { |feed| feed.valid? }
    end
  end

  def fetch(consumer = FeedConsumer.new)
    consumer.consume(self)
  end
end
