class Feed < ActiveRecord::Base

  has_many :stories, -> { order 'published DESC' }
  has_many :subscriptions

  validates :url, presence: true, uniqueness: true

  # delete unsubscribed feeds
  def self.cleanup!
  end

  def self.add(url, finder = FeedFinder.new)
    feed = find_by_url(url)
    return Array(feed) if feed

    finder.find(url).map { |url|
      Feed.create
    }.select { |feed| feed.valid? }
  end
end
