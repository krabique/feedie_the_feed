require 'feedjira'

require 'feedie_the_feed/exceptions'

module FeedieTheFeed
  # This module handles RSS queries
  module RSS
    private

    def get_rss_feed(url)
      feed = Feedjira::Feed.fetch_and_parse(url)
      feed.entries.map!(&:to_h)
    rescue Feedjira::NoParserAvailable => e
      raise BadUrl.new("The url provided doesn't seem to contain any feed.", e)
    end
  end
end
