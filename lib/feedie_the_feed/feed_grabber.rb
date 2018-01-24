require 'uri'
require 'public_suffix'

require 'feedie_the_feed/exceptions'

require 'feedie_the_feed/facebook'
require 'feedie_the_feed/rss'

module FeedieTheFeed
  # This is the main class that does all the job.
  class FeedGrabber
    include FeedieTheFeed::Facebook
    include FeedieTheFeed::RSS

    Feedjira.logger.level = Logger::FATAL

    def initialize(options = {})
      @defaults = { facebook_posts_limit: 10 }
      @facebook_appid_global = options[:facebook_appid]
      @facebook_secret_global = options[:facebook_secret]
      fb_posts_limit(
        options[:facebook_posts_limit] || @defaults[:facebook_posts_limit]
      )
      @url = options[:url]
    end

    def get(options = {})
      url = sanitise_web_url(@url)
      if facebook_url?(url)
        get_facebook_feed(url, options)
      else
        get_rss_feed(url)
      end
    rescue Faraday::ConnectionFailed => e
      raise ConnectionFailed, e
    end

    def reset_fb_appid_and_secret_key!
      @facebook_appid_global = nil
      @facebook_secret_global = nil
    end

    def fb_appid_and_secret_key(facebook_appid, facebook_secret)
      if facebook_appid.is_a?(String) && facebook_secret.is_a?(String)
        @facebook_appid_global = facebook_appid
        @facebook_secret_global = facebook_secret
      else
        raise BadFacebookAppIDAndSecretKey, 'Facebook AppID and secret key ' \
          'must be strings (input classes: ' \
          "#{facebook_appid.class} and #{facebook_secret.class})"
      end
    end

    def reset_fb_posts_limit!
      @facebook_posts_limit_global = @defaults[:facebook_posts_limit]
    end

    def fb_posts_limit(limit)
      valid_facebook_posts_limit?(limit)
      @facebook_posts_limit_global = limit
    end

    private

    def sanitise_web_url(url)
      url = "https://#{url}" unless url =~ %r{\A(http|https)://}
      url
    end

    def facebook_url?(url)
      uri = URI.parse(url)
      PublicSuffix.parse(uri.host).domain == 'facebook.com'
    rescue PublicSuffix::DomainInvalid => e
      raise BadUrl.new("The url provided doesn't seem to be valid. " \
        "(url: #{url})", e)
    end
  end
end
