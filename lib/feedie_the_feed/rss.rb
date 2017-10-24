require 'feedjira'

require 'feedie_the_feed/exceptions'

module FeedieTheFeed
  # This module handles RSS queries
  module RSS
    private

    def get_rss_feed(url)
      feedjira_feed = Feedjira::Feed.fetch_and_parse(url)
      feed = feedjira_feed.entries.map!(&:to_h)
      sanitise_feed(feed)
    rescue Feedjira::NoParserAvailable => e
      raise BadUrl.new("The url provided doesn't seem to contain any feed. " \
        "(url: #{url})", e)
    end

    def sanitise_feed(feed)
      feed.each do |entry|
        entry['entry_id'] = entry['url'] if entry['entry_id'].nil?
      end
    end
  end
end
