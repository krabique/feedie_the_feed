describe FeedieTheFeed do
  context 'When testing the FeedieTheFeed module' do
    facebook_page = 'https://www.facebook.com/ruby.programming'
    facebook_appid = ENV['FACEBOOK_APPID']
    facebook_secret = ENV['FACEBOOK_SECRET']

    it 'should return feed when we call the get class method' do
      FeedieTheFeed.get(facebook_page)
    end

    it 'should return feed when we call the get class method with ' \
      'Facebook AppID and secret key provided in the call' do
      FeedieTheFeed.get(
        facebook_page,
        facebook_appid: facebook_appid,
        facebook_secret: facebook_secret
      )
    end
  end
end
