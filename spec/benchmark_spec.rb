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
      require "benchmark/memory"
      @iterations = 100
      
      def many_objects(facebook_page, facebook_appid, facebook_secret)
        feed_grabber = FeedieTheFeed::FeedGrabber.new(
          url: facebook_page,
          facebook_appid: facebook_appid,
          facebook_secret: facebook_secret
        )
        
        feed_grabber.get
      end
      
      Benchmark.bm do |bm|
        bm.report do
          @iterations.times do
            many_objects(facebook_page, facebook_appid, facebook_secret)
          end
        end
      end
      
      Benchmark.memory do |x|
        x.report("many objects") { 
          @iterations.times do
            many_objects(facebook_page, facebook_appid, facebook_secret)
          end
        }
      end
      
    end
    
  end
end