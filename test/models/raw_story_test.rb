require 'test_helper'

class RawStoryTest < ActiveSupport::TestCase

  def setup
    @feedzirra_story = raw_stories(1).first
  end

  test 'can normalize feedzirra story' do
    raw_story = RawStory.new(@feedzirra_story)
    %w(id published updated permalink body author).each do |method|
      refute_nil raw_story.send(method)
    end
  end
end
