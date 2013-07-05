require 'test_helper'

class FeedFinderTest < ActiveSupport::TestCase

  def setup
    @feedbag = Minitest::Mock.new
    @feed_finder = FeedFinder.new(@feedbag)
    @url = 'http://example.com/feed'
  end
  
  test 'can find feeds' do
    @feedbag.expect :find, [@url], [String]
    assert_equal [@url], @feed_finder.find('http://example.com')
  end
end
