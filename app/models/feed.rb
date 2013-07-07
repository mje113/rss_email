class Feed < ActiveRecord::Base

  has_many :stories, -> { order 'published DESC' }
  has_many :subscriptions

  validates :url, presence: true, uniqueness: true

  # delete unsubscribed feeds
  def self.cleanup!
  end

  def self.add(url, finder = FeedFinder.new)
    if feed = find_by_url(url)
      Array(feed)
    else
      finder.find(url).map { |url|
        find_by_url(url) || create(url: url, last_fetched: 30.days.ago)
      }.select { |feed| feed.valid? }
    end
  end

  def fetch(consumer = FeedConsumer.new)
    raw_feed = consumer.consume(self.url)

    update_from_raw_feed(raw_feed)
  end

  def self.batch_fetch(feeds, consumer = FeedConsumer.new)
    raw_feeds = consumer.batch_fetch(feeds.map(&:url))

    feeds.each do |raw_feed|
      update_from_raw_feed(raw_feed)
    end
  end

  private

  def update_from_raw_feed(raw_feed)
    # Add new stories
    raw_feed.new_stories(last_fetched).each do |story|
      add_story_from_raw(story)
    end
    update_from_raw_feed(raw_feed)
  end

  def update_feed_from_raw(raw_feed)
    update_attributes(
      name: raw_feed.name,
      last_fetched: Time.now
    )
  end

  def add_story_from_raw(raw_story)
    stories << Story.create_from_raw(raw_story)
  end
end
