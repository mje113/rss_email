require 'feedbag'

class Utils::FeedFinder

  def initialize(finder = Feedbag)
    @finder = finder
  end

  def find(url)
    @finder.find(url)
  end

end
