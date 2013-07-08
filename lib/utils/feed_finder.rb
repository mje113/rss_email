require 'feedbag'

# FeedFinder is a Util class that facilitates finding valid feeds (via Feedbag)
class Utils::FeedFinder

  def initialize(finder = Feedbag)
    @finder = finder
  end

  def find(url)
    @finder.find(url)
  end

end
