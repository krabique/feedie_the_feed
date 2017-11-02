require 'feedie_the_feed/feed_grabber'

# This is the main namespace of the gem
module FeedieTheFeed
  # {FeedGrabber#get}
  def self.get(url, options = {})
    FeedGrabber.new.get(url, options)
  end
end
