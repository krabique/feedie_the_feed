require 'webmock/rspec'

require 'support/fake_facebook'
require 'support/fake_rss'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, /graph.facebook.com\/oauth\/access_token/)
      .to_return(status: 200)
    stub_request(:post, /graph.facebook.com\/oauth\/access_token/)
      .with(body: {"client_id"=>"123", "client_secret"=>"123",
                   "grant_type"=>"client_credentials"})
      .to_rack(FakeFacebook)
    # stub_request(:post, "https://graph.facebook.com/oauth/access_token").
    #   with(body: {"client_id"=>"458198461180322", "client_secret"=>"9aa06d1c9321cef9ab0d3ecace3d7e22", "grant_type"=>"client_credentials"},
    #   headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Faraday v0.13.1'}).
    #   to_return(status: 200, body: "", headers: {})    
      
    stub_request(:get, /rss_test_sample/).to_rack(FakeRSS)
    stub_request(:get, /graph.facebook.com\/PokerGP/).to_return(status: 200)
    stub_request(:get, /google.com/).to_return(status: 200)      
    stub_request(:get, /graph.facebook.com\/nrtsrns/).to_rack(FakeFacebook)
    stub_request(:get, /ndrnrt.com/).to_timeout
  end
end
