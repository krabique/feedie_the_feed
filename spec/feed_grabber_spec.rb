require 'simplecov'

require 'feedie_the_feed'

require 'spec_helper'

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

    context 'with Facebook pages' do
      facebook_page = 'https://www.facebook.com/ruby.programming'
      facebook_appid = ENV['FACEBOOK_APPID']
      facebook_secret = ENV['FACEBOOK_SECRET']

      it 'should return feed when we call the get instance method ' \
        'with Facebook credentials included in the call' do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new
        f = @feed_grabber.get(
          facebook_page,
          facebook_appid: facebook_appid,
          facebook_secret: facebook_secret
        )
        expect(f).to be_truthy
      end

      it 'should return feed when we call the get instance method ' \
        "with Facebook credentials provided through the object's " \
        'global values' do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new(
          facebook_appid: facebook_appid,
          facebook_secret: facebook_secret
        )
        f = @feed_grabber.get(facebook_page)
        expect(f).to be_truthy
      end

      it 'should return feed when we call the get instance method ' \
        'with Facebook credentials not included anywhere, and thus provided' \
        'by the environment variables FACEBOOK_APPID and FACEBOOK_SECRET' do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new
        f = @feed_grabber.get(facebook_page)
        expect(f).to be_truthy
      end

      it 'should return feed when we call the get instance method with ' \
        'Facebook credentials as parameters, even if Facebook credentials ' \
        'have already been ' \
        'provided on class instance creation' do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new(
          facebook_appid: 'bad_appid',
          facebook_secret: 'bad_secret'
        )
        f = @feed_grabber.get(
          facebook_page,
          facebook_appid: facebook_appid,
          facebook_secret: facebook_secret
        )
        expect(f).to be_truthy
      end

      it 'should return an array of hashes with certain keys when we ' \
        'use the get instance method' do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new
        feed = @feed_grabber.get(facebook_page)
        expect(feed).to be_a(Array)
        feed.each do |entry|
          expect(entry).to be_a(Hash)

          expect(entry).to have_key('entry_id')
          expect(entry).to have_key('title')
          expect(entry).to have_key('summary')
          expect(entry).to have_key('url')
          expect(entry).to have_key('published')
          expect(entry).to have_key('image')
        end
      end

      it 'should raise FeedieTheFeed::BadFacebookPageName exception when ' \
        'we are trying to call the get instance method with a unvalid ' \
        'Facebook page name' do
        expect do
          @feed_grabber = FeedieTheFeed::FeedGrabber.new
          # Some non-existent page
          facebook_page = 'https://www.facebook.com/not_existing_page'
          @feed_grabber.get(facebook_page)
        end.to raise_error(FeedieTheFeed::BadFacebookPageName)
      end
    end

    context 'with RSS feed' do
      rss_feed = 'https://abc.com/rss'

      it 'should return feed when we use the get instance method' do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new
        f = @feed_grabber.get(rss_feed)
        expect(f).to be_truthy
      end

      it 'should return an array of hashes with certain keys when we ' \
        'use the get instance method' do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new
        feed = @feed_grabber.get(rss_feed)

        expect(feed).to be_a(Array)
        feed.each do |entry|
          expect(entry).to be_a(Hash)

          expect(entry).to have_key('entry_id')
          expect(entry).to have_key('title')
          expect(entry).to have_key('summary')
          expect(entry).to have_key('url')
          expect(entry).to have_key('published')
          expect(entry).to have_key('image')
        end
      end
    end

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
      expect(@feed_grabber.instance_variable_get(:@facebook_appid_global))
        .to eq facebook_appid
      expect(@feed_grabber.instance_variable_get(:@facebook_secret_global))
        .to eq facebook_secret
      expect(
        @feed_grabber.instance_variable_get(:@facebook_posts_limit_global)
      ).to eq facebook_posts_limit
    end

    it 'should create new FeedGrabber class instance with nil ' \
      'values for @facebook_appid_global, @facebook_secret_global, ' \
      'and default value for @facebook_posts_limit_global from ' \
      '@defaults[:facebook_posts_limit] ' do
      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      expect(@feed_grabber.instance_variable_get(:@facebook_appid_global))
        .to eq nil
      expect(@feed_grabber.instance_variable_get(:@facebook_secret_global))
        .to eq nil
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
      'nil when we call the reset_fb_appid_and_secret_key! method' do
      initial_facebook_appid = '123'
      initial_facebook_secret = '123'
      @feed_grabber = FeedieTheFeed::FeedGrabber.new(
        facebook_appid: initial_facebook_appid,
        facebook_secret: initial_facebook_secret
      )
      @feed_grabber.reset_fb_appid_and_secret_key!
      changed_facebook_appid =
        @feed_grabber.instance_variable_get(:@facebook_appid_global)
      changed_facebook_secret =
        @feed_grabber.instance_variable_get(:@facebook_secret_global)

      expect(changed_facebook_appid).to eq nil
      expect(changed_facebook_secret).to eq nil
    end

    it 'should raise FeedieTheFeed::FacebookAuthorisationError exception ' \
      'when trying to use the get instance method of FeedGrabber class with ' \
      'wrong Facebook AppID and Facebook secret key' do
      @feed_grabber = FeedieTheFeed::FeedGrabber.new(
        facebook_appid: 'bad_appid',
        facebook_secret: 'bad_secret'
      )
      expect do
        @feed_grabber.get('https://www.facebook.com/ruby.programming')
      end.to raise_error(FeedieTheFeed::FacebookAuthorisationError)

      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      expect do
        @feed_grabber.get('https://www.facebook.com/ruby.programming',
                          facebook_appid: 'bad_appid',
                          facebook_secret: 'bad_secret')
      end.to raise_error(FeedieTheFeed::FacebookAuthorisationError)
    end

    it 'should raise FeedieTheFeed::BadUrl exception when we call the get ' \
      'instance method with an unvalid URL link' do
      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      links = ['http', 'https', 'http:', 'https:', 'http:/', 'https:/',
               'http://', 'https://', 'http://google', 'http://google.',
               'google.com', 'abc']
      links.each do |link|
        expect do
          @feed_grabber.get(link)
        end.to raise_error(FeedieTheFeed::BadUrl)
      end
    end

    it 'should raise FeedieTheFeed::BadUrl exception when we call the get ' \
      'instance method with a URL link that does not contain a feed' do
      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      links = ['https://google.com', 'http://google.com/']
      links.each do |link|
        expect do
          @feed_grabber.get(link)
        end.to raise_error(FeedieTheFeed::BadUrl)
      end
    end

    it 'should raise FeedieTheFeed::BadFacebookPostsLimit exception when ' \
      'calling fb_posts_limit(limit) instance method with a non integer ' \
      'limit value or a value ' \
      'that is not in range of 1 to 100 as the Facebook posts limit' do
      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      expect do
        limit_value = 0
        @feed_grabber.fb_posts_limit(limit_value)
      end.to raise_error(FeedieTheFeed::BadFacebookPostsLimit)

      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      expect do
        limit_value = -1
        @feed_grabber.fb_posts_limit(limit_value)
      end.to raise_error(FeedieTheFeed::BadFacebookPostsLimit)

      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      expect do
        limit_value = 101
        @feed_grabber.fb_posts_limit(limit_value)
      end.to raise_error(FeedieTheFeed::BadFacebookPostsLimit)
    end

    it 'should raise FeedieTheFeed::BadFacebookPostsLimit exception when ' \
      'creating a new instance of FeedGrabber class with a non integer ' \
      'limit value or a value ' \
      'that is not in range of 1 to 100 as the Facebook posts limit' do
      expect do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new(facebook_posts_limit: 0)
      end.to raise_error(FeedieTheFeed::BadFacebookPostsLimit)
      expect do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new(facebook_posts_limit: -1)
      end.to raise_error(FeedieTheFeed::BadFacebookPostsLimit)
      expect do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new(
          facebook_posts_limit: -100
        )
      end.to raise_error(FeedieTheFeed::BadFacebookPostsLimit)
    end

    it 'should raise FeedieTheFeed::BadFacebookPostsLimit exception when ' \
      'calling the get instance method with a non integer ' \
      'limit value or a value ' \
      'that is not in range of 1 to 100 as the Facebook posts limit' do
      facebook_page = 'https://www.facebook.com/ruby.programming'
      expect do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new
        @feed_grabber.get(facebook_page, facebook_posts_limit: 0)
      end.to raise_error(FeedieTheFeed::BadFacebookPostsLimit)

      expect do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new
        @feed_grabber.get(
          facebook_page,
          facebook_posts_limit: -1
        )
      end.to raise_error(FeedieTheFeed::BadFacebookPostsLimit)

      expect do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new
        @feed_grabber.get(
          facebook_page,
          facebook_posts_limit: 101
        )
      end.to raise_error(FeedieTheFeed::BadFacebookPostsLimit)
    end

    it 'should raise FeedieTheFeed::ConnectionFailed exception when calling ' \
      'get instance method with a URL link to a non-existent resource' do
      expect do
        @feed_grabber = FeedieTheFeed::FeedGrabber.new
        # some random non-existent url
        url = 'http://ndrnrt.com'
        @feed_grabber.get(url)
      end.to raise_error(FeedieTheFeed::ConnectionFailed)
    end

    it 'should return feed with either having an https:// (or http://) ' \
      "prefix, or not having it at all (i.e. 'www.facebook.com/abc' and " \
      "'https://www.facebook.com/abc'" do
      @feed_grabber = FeedieTheFeed::FeedGrabber.new

      facebook_page = 'https://www.facebook.com/ruby.programming'
      feed = @feed_grabber.get(facebook_page)
      expect(feed).to be_truthy

      facebook_page = 'http://www.facebook.com/ruby.programming'
      feed = @feed_grabber.get(facebook_page)
      expect(feed).to be_truthy

      facebook_page = 'www.facebook.com/ruby.programming'
      feed = @feed_grabber.get(facebook_page)
      expect(feed).to be_truthy
    end

    it 'should set @facebook_appid_global and @facebook_secret_global to ' \
      'provided values when we call the ' \
      'fb_appid_and_secret_key(appid, secret) instance method' do
      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      initial_appid = '123abc'
      initial_secret = '123abc'
      @feed_grabber.fb_appid_and_secret_key(initial_appid, initial_secret)

      changed_appid =
        @feed_grabber.instance_variable_get(:@facebook_appid_global)
      changed_secret =
        @feed_grabber.instance_variable_get(:@facebook_secret_global)

      expect(changed_appid).to eq initial_appid
      expect(changed_secret).to eq initial_secret
    end

    it 'should raise FeedieTheFeed::BadFacebookAppIDAndSecretKey ' \
      'exception when we call ' \
      'the fb_appid_and_secret_key(appid, secret) instance method with ' \
      'non-string parameters' do
      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      initial_appid = 123
      initial_secret = 123

      expect do
        @feed_grabber.fb_appid_and_secret_key(initial_appid, initial_secret)
      end.to raise_error(FeedieTheFeed::BadFacebookAppIDAndSecretKey)
    end
  end
end
