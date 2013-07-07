require 'test_helper'

class FeedTest < ActiveSupport::TestCase

  def setup
    @feedbag = Minitest::Mock.new
    @feed_finder = Utils::FeedFinder.new(@feedbag)
    @url = 'http://example.com/feed'
    @feeds = [
      Feed.new(name: 'My Blog', url: 'http://example.com/blog'),
      Feed.new(name: 'Your Blog', url: 'http://sample.com/blog')
    ]
  end

  test 'can add feeds' do
    @feedbag.expect :find, [@url], [String]
    size = Feed.count
    feeds = Feed.add(@url, @feed_finder)
    assert_equal size + 1, Feed.count
    assert feeds.first.is_a?(Feed)
  end

  test 'can fetch feed' do
    
  end

end
