require 'feedie_the_feed'

links_fb =  ['https://www.facebook.com/ruby.programming',
             'https://www.facebook.com/leagueoflegends/',
             'https://www.facebook.com/Defense0fTheAncients/']

links_rss = ['http://abcnews.go.com/abcnews/topstories',
             'http://rss.cnn.com/rss/edition_world.rss',
             'http://feeds.bbci.co.uk/news/world/rss.xml']

# Will use FACEBOOK_APPID and FACEBOOK_SECRET environment variables, if those
# provided here are nil
options = {
  facebook_appid:       nil,
  facebook_secret:      nil,
  facebook_posts_limit: nil
}

@feed_grabber = FeedieTheFeed::FeedGrabber.new

def get_feed(links, options = {})
  links.each do |link|
    feed = @feed_grabber.get(link, options)
    feed.first.each { |v| p v }
    p '----------------------------------'
  end
end

# # Uncomment and change these accordingly if you want to provide the keys on
# # object creation, instead of using those from environment variables
# # FACEBOOK_APPID and FACEBOOK_SECRET
# options = {
#   facebook_appid:       '123',
#   facebook_secret:      '123',
#   facebook_posts_limit: 10
# }
# @feed_grabber = FeedieTheFeed::FeedGrabber.new(options)
# options = {}

p ' -------- HERE GOOOOOOOOOOOOES ----- FACEBOOK --'
get_feed(links_fb, options)

p ' -------- HERE GOOOOOOOOOOOOES ----- RSS --'
get_feed(links_rss)
