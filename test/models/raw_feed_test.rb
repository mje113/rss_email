require 'test_helper'

class RawFeedTest < ActiveSupport::TestCase

  def setup
    @feedzirra_feed = OpenStruct.new(
      title: 'My Blog',
      last_modified: 1.day.ago,
      entries: raw_stories(10)
    )
    @raw_feed = RawFeed.new(@feedzirra_feed)
  end

  test 'can normalize feedzirra feed' do
    assert_equal 'My Blog', @raw_feed.name
    @raw_feed.stories.each do |story|
      assert story.is_a?(RawStory)
    end
  end

  test 'can select new stories' do
    assert_equal 5, @raw_feed.new_stories(5.days.ago).size
  end

end
