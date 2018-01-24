require 'feedie_the_feed'

require 'spec_helper'


# rubocop:disable Metrics/BlockLength
describe FeedieTheFeed::FeedGrabber do
  context 'with Facebook pages' do
    facebook_page = 'https://www.facebook.com/ruby.programming'
    facebook_appid = ENV['FACEBOOK_APPID']
    facebook_secret = ENV['FACEBOOK_SECRET']
    
    it 'benchmarks like a boss!' do
      @feed_grabber = FeedieTheFeed::FeedGrabber.new
      
      require 'benchmark'
      iterations = 1000

      Benchmark.bm do |bm|
        bm.report do
          iterations.times do
            f = @feed_grabber.get(
              facebook_page,
              facebook_appid: facebook_appid,
              facebook_secret: facebook_secret
            )
          end
        end
      end
      
      # include RSpec::Benchmark::Matchers
      
      # expect(f).to be_truthy
    end
    
  end
end