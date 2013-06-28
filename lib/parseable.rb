require 'feedzirra'

module Parseable
  
  def self.included(klass)
    klass.class_eval do
      extend ClassMethods
    end
  end
  
  module ClassMethods
  end
  
  def consume_feed
    return unless self.enabled?
    if twitter_searcher?
      return
      consume_twitter_searcher
    elsif twitter?
      return
      consume_twitter_feed
    else
      consume_blog_feed
    end
  end
  
  def consume_blog_feed
    if feed.nil? || feed.class == Fixnum
      miss_feed
      reparse_feed
      return
    else
      update_attribute(:missed_feed_count, 0)
    end
    
    feed.entries.each do |entry|
      
      published_at = begin
        if entry.published.is_a?(Time)
          entry.published
        else
          Time.parse(entry.published)
        end
      rescue
        Time.now
      end

      begin
        next if Post.find_by_uid(entry.id) || Post.find_by_external_url(entry.url)
        next if !entry.published.blank? && self.posts.find_by_name_and_published_at(entry.title, published_at)
        next if published_at < 30.days.ago
      rescue
        next
      end

      post = self.posts.new({
        :uid          => entry.id,
        :name         => (entry.title.sanitize.to_utf8   rescue nil),
        :author       => (entry.author.sanitize.to_utf8  rescue nil),
        :description  => (entry.summary.sanitize.to_utf8 rescue nil),
        :body         => (entry.content.sanitize.to_utf8 rescue nil) || (entry.summary.sanitize.to_utf8 rescue nil),
        :published_at => published_at,
        :external_url => entry.url
      })
      
      post.published_at = Time.now if post.published_at.nil? || post.published_at > Time.now
      post.tag_list = entry.categories.join(', ') if entry.categories
      
      # Tag validation was failing for some reason
      begin
        post.save
        self.update_attribute(:last_post_id, post.id)
      rescue
        post.tag_list = ''
        post.save
      end
    end
  end
  
  def feed
    begin
      @feed ||= Feedzirra::Feed.fetch_and_parse(self.external_feed,
        :user_agent => PortfoliBot::USER_AGENT
      )
    rescue
      logger.error "Error grabbing rss for #{self.name}"
    end
  end
  
  def consume_twitter_searcher
    self.twitter_searcher.consume_search
  end
  
  def consume_twitter_feed
    # find interesting tweets
    tweets = twitter_json_feed.select {|t| t['text'] =~ /http:\/\//}
    
    # remove already found tweets
    tweets = tweets.select {|t| Tweet.count(:conditions => ['tweet_id = ?', t['id']]) == 0}
    
    return if tweets.empty?
    
    tweets.each do |t|
      self.tweets.create(
        :tweet_id     => t['id'],
        :content      => t['text'],
        :published_at => t['created_at']
      )
    end
  end
  
  def twitter_json_feed
    @twitter_json_feed ||= parse_json(PortfoliBot.scrape(normalized_twitter_feed))
  end
  
  def parse_json(json)
    begin
      return JSON.parse(json)
    rescue
      # JSON chokes on parsing some feeds
      puts "cracking"
      return Crack::JSON.parse(json)
    end
  end
  
  def twitter_feed_to_api
    if twitter?
      if self.external_feed =~ /^@/
        
      else
        
      end
    end
  end
  
  def reparse_feed
    get_fields_from_external_url
    self.external_feed = lookup_feed if self.external_feed.blank?
    save
  end
  
end


# 
# # fetching a single feed
# feed = Feedzirra::Feed.fetch_and_parse("http://feeds.feedburner.com/PaulDixExplainsNothing")
# 
# # feed and entries accessors
# feed.title          # => "Paul Dix Explains Nothing"
# feed.url            # => "http://www.pauldix.net"
# feed.feed_url       # => "http://feeds.feedburner.com/PaulDixExplainsNothing"
# feed.etag           # => "GunxqnEP4NeYhrqq9TyVKTuDnh0"
# feed.last_modified  # => Sat Jan 31 17:58:16 -0500 2009 # it's a Time object
# 
# entry = feed.entries.first
# entry.title      # => "Ruby Http Client Library Performance"
# entry.url        # => "http://www.pauldix.net/2009/01/ruby-http-client-library-performance.html"
# entry.author     # => "Paul Dix"
# entry.summary    # => "..."
# entry.content    # => "..."
# entry.published  # => Thu Jan 29 17:00:19 UTC 2009 # it's a Time object
# entry.categories # => ["...", "..."]
# 
# # sanitizing an entry's content
# entry.title.sanitize   # => returns the title with harmful stuff escaped
# entry.author.sanitize  # => returns the author with harmful stuff escaped
# entry.content.sanitize # => returns the content with harmful stuff escaped
# entry.content.sanitize! # => returns content with harmful stuff escaped and replaces original (also exists for author and title)
# entry.sanitize!         # => sanitizes the entry's title, author, and content in place (as in, it changes the value to clean versions)
# feed.sanitize_entries!  # => sanitizes all entries in place
# 
# 
# 
# def consume_blog_feed
#   # self.name         = self.name.blank? ? rss.feed.title : self.name
#   # self.external_url = self.external_url.blank? ? rss.feed.link.gsub(/<link>/, '') : self.external_url
#   # self.favicon_url  = self.favicon_url.blank? ? get_favicon_url_from_external_url : self.favicon_url
#   # populate_favicon_from_url unless self.favicon?
#   # self.save
#   
#   rss.entries.each do |entry|
#     
#     next if Post.find_by_uid(entry.id) || Post.find_by_external_url(entry.link)
#     
#     post = self.posts.new({
#       :uid          => entry.id,
#       :name         => entry['title'],
#       :author       => entry['author'],
#       :description  => entry['contentSnippet'],
#       :body         => Sanitize.clean(entry['content'], Sanitize::Config::RELAXED),
#       :published_at => entry['publishedDate'],
#       :external_url => entry['link']
#     })
#     
#     post = Post.new(:uid => uid)
#     post.blog ||= self
#     post.consume_entry(entry)
#   end
#   touch
# end
# 
# 
# def consume_entry(entry)
#   self.published_at = entry.pubDate || entry.published
#   #return if self.published_at < 3.days.ago
#   self.external_url = entry.link
#   self.name         = CGI::unescapeHTML(entry.title)
#   self.author       = entry.author
#   self.description  = parse_description(entry)
#   self.body         = parse_body(entry)
#   self.tag_list     = entry.category
#   save
# end