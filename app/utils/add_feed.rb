module AddFeed
  
  def add(feed, finder = FeedFinder.new)
    feeds = finder.find(feed)
  end
end