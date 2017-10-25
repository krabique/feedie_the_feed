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

    # Stops feedjira spamming in console when there is no last modified time
    # field in an rss feed
    Feedjira.logger.level = Logger::FATAL

    # Returns a new instance of FeedGrabber.
    #
    # @param options [Hash] The options to use for the FeedGrabber constructor
    # @option options [String] :facebook_appid The Facebook AppID to be used
    #   globally in this object
    # @option options [String] :facebook_secret The Facebook secret key to be
    #   used globally in this object
    # @option options [Integer] :facebook_posts_limit The amount of Facebook
    #   posts to get by default (should be in 1..100)
    #
    # @raise [BadFacebookPostsLimit] Exception used when Facebook posts limit is
    #   out of range or not an integer
    def initialize(options = {})
      # This hash is used to store default values for things like Facebook posts
      # limit.
      @defaults = { facebook_posts_limit: 10 }
      @facebook_appid_global = options[:facebook_appid]
      @facebook_secret_global = options[:facebook_secret]
      fb_posts_limit(
        options[:facebook_posts_limit] || @defaults[:facebook_posts_limit]
      )
    end

    # Gets an array of hashes that are RSS or Facebook posts.
    #
    # @param url [String] The URL to be used as the feed source
    # @param options [Hash] The options to use for the get method
    # @option options [Integer] :facebook_posts_limit Amout of Facebook posts
    #   to get in this operation (should be in 1..100 range)
    # @option options [String] :facebook_appid Facebook AppID value to be used
    #   with this operation
    # @option options [String] :facebook_secret Facebook secret key value to be
    #   used with this operation
    #
    # @raise [FacebookAuthorisationError] Exception used when Facebook
    #   authorisation fails with the given credentials
    # @raise [BadUrl] Exception used when the RSS or Facebook link provided
    #   isn't a valid one
    # @raise [BadFacebookPostsLimit] Exception used when Facebook posts limit is
    #   out of range or not an integer
    # @raise [ConnectionFailed] Exception used when TCP connection could not be
    #   established
    #
    # @return [Array] The array of hashes of RSS entries or Facebook posts
    def get(url, options = {})
      url = sanitise_web_url(url)
      if facebook_url?(url)
        get_facebook_feed(url, options)
      else
        get_rss_feed(url)
      end
    rescue Faraday::ConnectionFailed => e
      raise ConnectionFailed, e
    end

    # Resets global Facebook AppID and secret key of this object.
    def reset_fb_appid_and_secret_key!
      @facebook_appid_global = nil
      @facebook_secret_global = nil
    end

    # Sets Facebook AppID and secret key for this object.
    #
    # @param facebook_appid [String] Facebook AppID to set to this object
    # @param facebook_secret [String] Facebook secret key to set to this object
    # @raise [BadFacebookAppIDAndSecretKey] Exception used when trying
    #   to set non-string Facebook AppID and secret key
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

    # Resets global Facebook posts limit of this object.
    def reset_fb_posts_limit!
      @facebook_posts_limit_global = @defaults[:facebook_posts_limit]
    end

    # Sets global Facebook posts limit for this object.
    #
    # @param limit [Integer] The number of posts to get on Facebook queries
    #   (should be in 1..100 range)
    # @raise [BadFacebookPostsLimit] Exception used when Facebook posts limit is
    #   out of range or not an integer
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
