require 'test_helper'

class FeedConsumerTest < ActiveSupport::TestCase

  def setup
    @urls = [
      'http://example.com/blog',
      'http://sample.com/blog'
    ]
  end
  
  test 'can consume feed' do
  end

  test 'can batch consume feeds' do
  end
end
