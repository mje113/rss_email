require 'test_helper'

class Utils::RawFeedTest < ActiveSupport::TestCase

  def setup
    @feedzirra_feed = feedzirra_feed
    @raw_feed = Utils::RawFeed.new(@feedzirra_feed)
  end

  test 'can normalize feedzirra feed' do
    assert_equal 'My Blog', @raw_feed.name
    @raw_feed.stories.each do |story|
      assert story.is_a?(Utils::RawStory)
    end
  end

  test 'can select new stories' do
    assert_equal 5, @raw_feed.new_stories(5.days.ago).size
  end

end
