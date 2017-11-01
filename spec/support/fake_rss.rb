require 'sinatra/base'

class FakeRSS < Sinatra::Base
  # get '/krabique48/feedie_the_feed/master/rss_test_sample' do
  # https://raw.githubusercontent.com
  get '/krabique48/feedie_the_feed/master/rss_test_sample' do
    # https://www.facebook.com/PokerGP
    json_response 200, 'rss_page.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
