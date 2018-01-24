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
      @iterations = 10
      
      def one_object(feed_grabber, facebook_page, facebook_appid, facebook_secret)
        feed_grabber.get(
          facebook_page,
          facebook_appid: facebook_appid,
          facebook_secret: facebook_secret
        )
      end
      
      def many_objects(facebook_page, facebook_appid, facebook_secret)
        @iterations.times do
          feed_grabber = FeedieTheFeed::FeedGrabber.new(
            facebook_appid: facebook_appid,
            facebook_secret: facebook_secret
          )
          
          feed_grabber.get(facebook_page)
        end        
      end


      # Benchmark time for both methods
      Benchmark.bm do |bm|
        bm.report do
          feed_grabber = FeedieTheFeed::FeedGrabber.new
          
          @iterations.times do
            one_object(feed_grabber, facebook_page, facebook_appid, facebook_secret)
          end
        end  
        
        bm.report do
          @iterations.times do
            many_objects(facebook_page, facebook_appid, facebook_secret)
          end
        end
      end

      # Benchmark memory for both methods
      Benchmark.memory do |x|
        x.report("one object") {
          feed_grabber = FeedieTheFeed::FeedGrabber.new
          
          @iterations.times do
            one_object(feed_grabber, facebook_page, facebook_appid, facebook_secret)
          end
        }
        
        x.report("many objects") {
          @iterations.times do
            many_objects(facebook_page, facebook_appid, facebook_secret)
          end
        }
        
        x.compare!
      end
    end
    
  end
end