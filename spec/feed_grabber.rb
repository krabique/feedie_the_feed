require 'feedie_the_feed'

# rubocop:disable Metrics/BlockLength
describe FeedieTheFeed::FeedGrabber do
  context 'When testing the FeedGrabber class' do

    it 'should set @facebook_posts_limit_global to the given limit ' \
      'value when we call the fb_posts_limit(limit) method' do
      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      value = rand(1..100)
      @feed_grabber.fb_posts_limit(value)
      output =
        @feed_grabber.instance_variable_get(:@facebook_posts_limit_global)
      expect(output).to eq value
    end

    it '#get'
    
    it 'should create new FeedGrabber class instance with the correct ' \
      'provided values for @facebook_appid_global, @facebook_secret_global ' \
      'and @facebook_posts_limit_global' do
      facebook_appid = 'abc123'
      facebook_secret = 'abc123'
      facebook_posts_limit = 33
      @feed_grabber = FeedieTheFeed::FeedGrabber.new(
        facebook_appid: facebook_appid,
        facebook_secret: facebook_secret,
        facebook_posts_limit: facebook_posts_limit
      )
      expect(@feed_grabber.instance_variable_get(:@facebook_appid_global)).
        to eq facebook_appid
      expect(@feed_grabber.instance_variable_get(:@facebook_secret_global)).
        to eq facebook_secret
      expect(
        @feed_grabber.instance_variable_get(:@facebook_posts_limit_global)
      ).to eq facebook_posts_limit
    end
    
    it 'should create new FeedGrabber class instance with nil ' \
      'values for @facebook_appid_global, @facebook_secret_global, ' \
      'and default value for @facebook_posts_limit_global from ' \
      '@defaults[:facebook_posts_limit] ' do
      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      expect(@feed_grabber.instance_variable_get(:@facebook_appid_global)).
        to eq nil
      expect(@feed_grabber.instance_variable_get(:@facebook_secret_global)).
        to eq nil
      expect(
        @feed_grabber.instance_variable_get(:@facebook_posts_limit_global)
      ).to eq(
        @feed_grabber.instance_variable_get(:@defaults)[:facebook_posts_limit]
      )
    end
      
    it 'should reset @facebook_posts_limit_global variable to a default ' \
      'value given in @defaults hash when we call ' \
      'the reset_fb_posts_limit! method' do
      initial_fb_posts_limit = rand(1..100)
      @feed_grabber = FeedieTheFeed::FeedGrabber.new(
        facebook_posts_limit: initial_fb_posts_limit
      )
      @feed_grabber.reset_fb_posts_limit!
      changed_fb_posts_limit =
        @feed_grabber.instance_variable_get(:@facebook_posts_limit_global)

      expect(changed_fb_posts_limit).to eq(
        @feed_grabber.instance_variable_get(:@defaults)[:facebook_posts_limit]
      )
    end

    it 'should set @facebook_appid_global and @facebook_secret_global to ' \
      'nil when we call the reset_keys! method' do
      initial_facebook_appid = '123'
      initial_facebook_secret = '123'
      @feed_grabber = FeedieTheFeed::FeedGrabber.new(
        facebook_appid: initial_facebook_appid,
        facebook_secret: initial_facebook_secret
      )
      @feed_grabber.reset_keys!
      changed_facebook_appid =
        @feed_grabber.instance_variable_get(:@facebook_appid_global)
      changed_facebook_secret =
        @feed_grabber.instance_variable_get(:@facebook_secret_global)

      expect(changed_facebook_appid).to eq nil
      expect(changed_facebook_secret).to eq nil
    end

    it 'exception FacebookAuthorisationError'
    it 'exception BadUrl'
    it 'exception BadFacebookPostsLimit'
    it 'exception ConnectionFailed'
  end
end
