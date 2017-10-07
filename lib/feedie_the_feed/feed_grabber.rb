require 'feedjira'
require 'koala'
require 'uri'
require 'public_suffix'

module FeedieTheFeed
  class FeedGrabber
    
    # Stops feedjira spamming in console when there is no last modified time field in an rss feed
    Feedjira.logger.level = Logger::FATAL    
    
    def initialize(facebook_appid=nil, facebook_secret=nil)
      @facebook_appid = facebook_appid
      @facebook_secret = facebook_secret
    end
    
    def get(url, facebook_appid=nil, facebook_secret=nil)
      set_facebook_credentials(facebook_appid, facebook_secret) if facebook_appid && facebook_secret
      validate_url_and_start(url)
    end

    private
        
    def set_facebook_credentials(facebook_appid, facebook_secret)
      @facebook_appid = facebook_appid
      @facebook_secret = facebook_secret
    end
    
    def validate_url_and_start(url)
      if url =~ /\A#{URI::regexp(['http', 'https'])}\z/
        get_proper_feed(url)
      else
        p "Bad url." #GOTA THROW EXCEPTION
      end      
    end
    
    def get_proper_feed(url)
      is_facebook_url?(url) ? get_facebook_feed(url) : get_rss_feed(url)
    end
    
    def is_facebook_url?(url)
      uri = URI.parse(url)
      PublicSuffix.parse(uri.host).domain == 'facebook.com'
    end
    
    def get_facebook_feed(url)
      authorize_facebook
      posts = @fb_graph_api.get_connection(get_fb_page_name(url), 'posts', {
        limit: 10, # max 100
        fields: ['message', 'id', 'from', 'type', 'picture', 'link', 'created_time']
      })
      formalize_fb_feed_array(posts.to_a)
    end
    
    def authorize_facebook
      @facebook_appid ||= ENV['FACEBOOK_APPID']
      @facebook_secret ||= ENV['FACEBOOK_SECRET']
      oauth = Koala::Facebook::OAuth.new(@facebook_appid, @facebook_secret)
      access_token = oauth.get_app_access_token
      @fb_graph_api = Koala::Facebook::API.new(access_token)    
    end
    
    def get_fb_page_name(url)
      URI.parse(url).path.match(/\A\/([^\/]*)/)[1]
    end

    def truncate(text, options = {})
      return text unless text.length > options[:length]
    
      omission = options[:omission] || "..."
      length_with_room_for_omission = options[:length] - omission.length
      stop = \
        if options[:separator]
          text.rindex(options[:separator], length_with_room_for_omission) || length_with_room_for_omission
        else
          length_with_room_for_omission
        end
    
      "#{text[0, stop]}#{omission}"
    end
    
    def formalize_fb_feed_array(array)
      array.each do |hash|
        hash['entry_id'] = hash.delete 'id'
        hash['summary'] = hash.delete 'message'
        hash['title'] = truncate(hash['summary'], length: 80, separator: ' ') if hash['summary']
        hash['url'] = hash.delete 'link'
        hash['published'] = Time.parse hash.delete('created_time')
        hash['image'] = hash.delete 'picture'
      end
    end  
    
    def get_rss_feed(url)
      feed = Feedjira::Feed.fetch_and_parse url
      feed.entries.map! do |entry|
        entry.to_h
      end
    end
    
  end
end
