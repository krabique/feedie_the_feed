require 'feedjira'
require 'koala'
require 'uri'
require 'public_suffix'

require 'feedie_the_feed/helper_extensions/string'

require 'feedie_the_feed/exceptions'

module FeedieTheFeed
  # This is the main class that does all the job.
  class FeedGrabber
    # Stops feedjira spamming in console when there is no last modified time
    # field in an rss feed
    Feedjira.logger.level = Logger::FATAL

    @@defaults = { facebook_posts_limit: 10 }

    def initialize(facebook_appid = nil, facebook_secret = nil,
                   facebook_posts_limit = @@defaults[:facebook_posts_limit])
      @facebook_appid_global = facebook_appid
      @facebook_secret_global = facebook_secret
      @facebook_posts_limit_global = facebook_posts_limit
    end

    def get(url, options = {})
      get_proper_feed(url,
                      options[:facebook_posts_limit],
                      options[:facebook_appid],
                      options[:facebook_secret])
    end

    def reset_keys!
      @facebook_appid_global = nil
      @facebook_secret_global = nil
    end

    def reset_fb_posts_limit!
      @facebook_posts_limit_global = @@defaults[:facebook_posts_limit]
    end

    def fb_posts_limit(limit)
      raise 'Facebook posts limit can only be an integer from 1 to 100' unless
        limit.is_a?(Integer) && limit < 100 && limit > 0
      @facebook_posts_limit_global = limit
    end

    private

    def get_proper_feed(url,
                        facebook_posts_limit,
                        facebook_appid,
                        facebook_secret)
      if facebook_url?(url)
        get_facebook_feed(url,
                          facebook_posts_limit,
                          facebook_appid,
                          facebook_secret)
      else
        get_rss_feed(url)
      end
    end

    def facebook_url?(url)
      uri = URI.parse(url)
      PublicSuffix.parse(uri.host).domain == 'facebook.com'
    rescue PublicSuffix::DomainInvalid => e
      raise BadUrl.new("The url provided doesn't seem to be valid", e)
    end

    def get_facebook_feed(url,
                          # for some unknown reason this shit won't default to
                          # @@defaults[:facebook_posts_limit], and keeps using
                          # nil instead, so a workaround is this line -->
                          facebook_posts_limit, #                        |
                          facebook_appid = @facebook_appid_global, #     |
                          facebook_secret = @facebook_secret_global) #   |
      authorise_facebook(facebook_appid, facebook_secret) #             /
      # may the gods forgive me                                        /
      facebook_posts_limit ||= @@defaults[:facebook_posts_limit] # <--/
      posts = @fb_graph_api.get_connection(
        get_fb_page_name(url),
        'posts',
        limit: facebook_posts_limit, # max 100
        fields: %w[message id from type picture link created_time]
      )
      formalize_fb_feed_array(posts.to_a)
    end

    def authorise_facebook(facebook_appid, facebook_secret)
      facebook_appid ||= ENV['FACEBOOK_APPID']
      facebook_secret ||= ENV['FACEBOOK_SECRET']
      oauth = Koala::Facebook::OAuth.new(facebook_appid, facebook_secret)

      begin
        access_token = oauth.get_app_access_token
      rescue Koala::Facebook::OAuthTokenRequestError => e
        raise FacebookAuthorisationError.new('Failing to authorise with ' \
          'given facebook_appid and facebook_secret.', e)
      end

      @fb_graph_api = Koala::Facebook::API.new(access_token)
    end

    def get_fb_page_name(url)
      URI.parse(url).path.match(
        %r{\A/([^/]*)}
      )[1]
    end

    def formalize_fb_feed_array(array)
      array.each do |hash|
        hash['entry_id'] = hash.delete('id')
        hash['summary'] = hash.delete('message')
        hash['title'] = hash['summary'].truncate(80) if hash['summary']
        hash['url'] = hash.delete('link')
        hash['published'] = Time.parse(hash.delete('created_time'))
        hash['image'] = hash.delete('picture')
      end
    end

    def get_rss_feed(url)
      feed = Feedjira::Feed.fetch_and_parse(url)
      feed.entries.map!(&:to_h)
    rescue Feedjira::NoParserAvailable => e
      raise BadUrl.new("The url provided doesn't seem to contain any feed.", e)
    end
  end
end
