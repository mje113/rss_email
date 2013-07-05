class RawFeed
  attr_accessor :name, :stories, :last_modified

  def initialize(feedzirra_feed)
    @name    = feedzirra_feed.title
    @stories = feedzirra_feed.entries.map { |entry|
      RawStory.new(entry)
    }
    @last_modified = feedzirra_feed.last_modified
  end

  def new_stories(last_fetched)
    @stories.select { |story|
      story.published && story.published < last_fetched
    }
  end
end
