require 'webmock/rspec'

require 'support/fake_facebook'
require 'support/fake_rss'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(/facebook.com/, /api.github.com/).to_rack(FakeFacebook)
    # stub_request(/raw.githubusercontent.com/).to_rack(FakeFacebook)
    stub_request(:post, "https://graph.facebook.com/oauth/access_token").
      with(body: {"client_id"=>"458198461180322", "client_secret"=>"9aa06d1c9321cef9ab0d3ecace3d7e22", "grant_type"=>"client_credentials"},
      headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.13.1'}).
      to_return(status: 200, body: "", headers: {})
    stub_request(:get, "https://raw.githubusercontent.com/krabique48/feedie_the_feed/master/rss_test_sample").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Feedjira 2.1.2'}).
      to_rack(FakeRSS)
    stub_request(:get, "http://graph.facebook.com/PokerGP/posts?fields=message,id,from,type,picture,link,created_time&limit=10").
        with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.13.1'}).
        to_return(status: 200, body: "", headers: {}).to_rack(FakeFacebook)
    
    stub_request(:get, /google.com/).to_return(status: 200, body: "", headers: {})      
    
    stub_request(:get, "http://graph.facebook.com/nrtsrns/posts?fields=message,id,from,type,picture,link,created_time&limit=10").
        with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.13.1'}).
        to_rack(FakeFacebook)
    
    stub_request(:get, "http://ndrnrt.com").to_return()      
  end
end
