require 'feedie_the_feed'

@feed_grabber = FeedieTheFeed::FeedGrabber.new

## Uncomment and change these accordingly if you want to provide the keys here,
## instead of using those from environment variables FACEBOOK_APPID and
## FACEBOOK_SECRET
# facebook_appid = "123"
# facebook_secret = "123"
# @feed_grabber = FeedieTheFeed::FeedGrabber.new(
#   facebook_appid, facebook_secret
# )

links_fb =  ['https://www.facebook.com/PokerGP',
             'https://www.facebook.com/leagueoflegends/',
             'https://www.facebook.com/Defense0fTheAncients/']

links_rss = ['http://abcnews.go.com/abcnews/topstories',
             'https://www.bsuir.by/rss?rubid=102243&resid=100229',
             'http://rss.cnn.com/rss/edition_world.rss',
             'http://feeds.bbci.co.uk/news/world/rss.xml']

def get_feed(links)
  links.each do |link|
    f = @feed_grabber.get(link)
    p 'entry_id: ' + f.first['entry_id']
    p 'title: ' + f.first['title']
    p 'summary: ' + f.first['summary']
    p 'url: ' + f.first['url']
    p 'published: ' + f.first['published'].to_s
    p 'image: ' + f.first['image'] if f.first['image']
    p '----------------------------------'
  end
end

p ' -------- HERE GOOOOOOOOOOOOES ----- FACEBOOK --'
get_feed links_fb

p ' -------- HERE GOOOOOOOOOOOOES ----- RSS --'
get_feed links_rss
