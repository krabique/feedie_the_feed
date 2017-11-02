require 'webmock/rspec'

require 'support/fake_facebook'
require 'support/fake_rss'

ENV['FACEBOOK_APPID'] = '123456'
ENV['FACEBOOK_SECRET'] = '456789'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, %r{graph.facebook.com/oauth/access_token})
      .to_return(status: 200)
    stub_request(:post, %r{graph.facebook.com/oauth/access_token})
      .with(body: { 'client_id' => '123',
                    'client_secret' => '123',
                    'grant_type' => 'client_credentials' })
      .to_rack(FakeFacebook)
    stub_request(:get, /rss_test_sample/).to_rack(FakeRSS)
    stub_request(:get, %r{graph.facebook.com/ruby.programming/})
      .to_return(status: 200)
    stub_request(:get, /google.com/).to_return(status: 200)
    stub_request(:get, %r{graph.facebook.com/not_existing_page})
      .to_rack(FakeFacebook)
    stub_request(:get, /ndrnrt.com/).to_timeout
  end
end
