require 'feedie_the_feed'

links_fb =  ['https://www.facebook.com/PokerGP',
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
    f = @feed_grabber.get(link, options)
    p 'entry_id: '  + f.first['entry_id']
    p 'title: '     + f.first['title'] if f.first['title']
    p 'summary: '   + f.first['summary'] if f.first['summary']
    p 'url: '       + f.first['url']
    p 'published: ' + f.first['published'].to_s if f.first['published']
    p 'image: '     + f.first['image'] if f.first['image']
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
