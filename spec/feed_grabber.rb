require 'feedie_the_feed'

describe FeedieTheFeed::FeedGrabber do
  context "When testing the FeedGrabber class" do   
    before(:each) { @feed_grabber = FeedieTheFeed::FeedGrabber.new }
    
    it "should set @facebook_posts_limit_global to the given limit " \
      "value when we call the fb_posts_limit(limit) method" do
      value = rand(1..100)
      @feed_grabber.fb_posts_limit(value)
      output = 
        @feed_grabber.instance_variable_get(:@facebook_posts_limit_global)
      expect(output).to eq value
    end
    
    it "#get"
    it "#initialize"
    it "#reset_fb_posts_limit"
    it "#reset_keys"
    
    it "exception FacebookAuthorisationError"
    it "exception BadUrl"
    it "exception BadFacebookPostsLimit"
    it "exception ConnectionFailed"
    
    it "String truncate"
  end
end
