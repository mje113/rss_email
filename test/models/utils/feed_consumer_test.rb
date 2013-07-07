require 'test_helper'
require 'ostruct'

class Fakezirra

  def initialize(fake_feed)
    @fake_feed = fake_feed
  end

  def fetch_and_parse(url, options = {})
    @fake_feed
  end
end

class Utils::FeedConsumerTest < ActiveSupport::TestCase

  def setup
    @urls = [
      'http://example.com/blog',
      'http://sample.com/blog'
    ]
    @feedzirra_feed = feedzirra_feed
    @fakezirra = Fakezirra.new(@feedzirra_feed)
    @consumer = Utils::FeedConsumer.new(@fakezirra)
  end
  
  test 'can consume feed' do
    raw_feed = @consumer.consume(@urls.first)

    assert_instance_of Utils::RawFeed, raw_feed
  end

  test 'can batch consume feeds' do
    raw_feeds = @consumer.batch_consume(@urls)

    keys, values = raw_feeds.keys, raw_feeds.values
    assert_equal @urls[0], keys[0]
    assert_equal @urls[1], keys[1]
    assert_instance_of Utils::RawFeed, values[0]
    assert_instance_of Utils::RawFeed, values[1]
  end
end
