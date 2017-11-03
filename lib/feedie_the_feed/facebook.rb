require 'koala'

require 'feedie_the_feed/exceptions'

require 'feedie_the_feed/helper_extensions/string'

module FeedieTheFeed
  # This module handles Facebook queries
  module Facebook
    private

    def valid_facebook_posts_limit?(limit)
      if limit.is_a?(Integer) && limit <= 100 && limit > 0
        limit
      else
        raise BadFacebookPostsLimit, 'Facebook posts limit can only be an ' \
          'integer from 1 to 100'
      end
    end

    def sanitized_facebook_posts_limit(facebook_posts_limit)
      if facebook_posts_limit
        valid_facebook_posts_limit?(facebook_posts_limit)
      else
        @defaults[:facebook_posts_limit]
      end
    end

    def get_facebook_feed(url, options)
      facebook_appid = options[:facebook_appid] || @facebook_appid_global
      facebook_secret = options[:facebook_secret] || @facebook_secret_global
      facebook_posts_limit =
        sanitized_facebook_posts_limit(options[:facebook_posts_limit])

      authorise_facebook(facebook_appid, facebook_secret)
      posts = facebook_api_query(url, facebook_posts_limit)
      formalize_fb_feed_array(posts.to_a)
    end

    def facebook_api_query(url, facebook_posts_limit)
      @fb_graph_api.get_connection(
        get_fb_page_name(url),
        'posts',
        limit: facebook_posts_limit, # max 100
        fields: %w[message id from type picture link created_time]
      )
    rescue Koala::Facebook::ClientError => e
      raise BadFacebookPageName.new("A Facebook page with that name doesn't " \
        "seem to exist. (name: #{get_fb_page_name(url)})", e)
    end

    def authorise_facebook(facebook_appid, facebook_secret)
      facebook_appid ||= ENV['FACEBOOK_APPID']
      facebook_secret ||= ENV['FACEBOOK_SECRET']
      oauth = Koala::Facebook::OAuth.new(facebook_appid, facebook_secret)

      begin
        access_token = oauth.get_app_access_token
      rescue Koala::Facebook::OAuthTokenRequestError => e
        raise FacebookAuthorisationError.new('Failing to authorise with ' \
          'given Facebook appid and Facebook secret key.', e)
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
        hash['summary'] = hash.delete('message') if hash['message']
        hash['title'] = hash['summary'].truncate(80) if hash['summary']
        hash['url'] = hash.delete('link')
        hash['published'] = Time.parse(hash.delete('created_time'))
        hash['image'] = hash.delete('picture')
      end
    end
  end
end
