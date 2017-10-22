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
    # @param facebook_appid [String] The Facebook AppID to be used globally in
    #   this object
    # @param facebook_secret [String] The Facebook secret key to be used
    #   globally in this object
    # @param facebook_posts_limit [Integer] The amount of Facebook posts to get
    #   by default (should be in 1..100)
    # @raise [BadFacebookPostsLimit] Exception used when Facebook posts limit is
    #   out of range or not an integer
    def initialize(facebook_appid = nil, facebook_secret = nil,
                   facebook_posts_limit = @@defaults[:facebook_posts_limit])
      @facebook_appid_global = facebook_appid
      @facebook_secret_global = facebook_secret
      fb_posts_limit(facebook_posts_limit)
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
      get_proper_feed(url,
                      options[:facebook_posts_limit],
                      options[:facebook_appid],
                      options[:facebook_secret])
    end

    # Resets global Facebook AppID and secret key of this object.
    def reset_keys!
      @facebook_appid_global = nil
      @facebook_secret_global = nil
    end

    # Resets global Facebook posts limit of this object.
    def reset_fb_posts_limit!
      @facebook_posts_limit_global = @@defaults[:facebook_posts_limit]
    end

    # Sets global Facebook posts limit for this object.
    #
    # @param limit [Integer] The number of posts to get on Facebook queries
    #   (should be in 1..100 range)
    # @raise [BadFacebookPostsLimit] Exception used when Facebook posts limit is
    #   out of range or not an integer
    def fb_posts_limit(limit)
      unless limit.is_a?(Integer) && limit <= 100 && limit > 0
        raise BadFacebookPostsLimit, 'Facebook posts limit can only be an ' \
          'integer from 1 to 100'
      end
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
    rescue Faraday::ConnectionFailed => e
      raise ConnectionFailed, e
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
