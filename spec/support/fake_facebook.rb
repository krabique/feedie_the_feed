require 'sinatra/base'

class FakeFacebook < Sinatra::Base
  # get '/repos/:organization/:project/contributors' do
  get '/PokerGP' do
    # https://www.facebook.com/PokerGP
    json_response 200, 'facebook_page.json'
  end
  
  get '/nrtsrns' do
    json_response 200, 'unvalid_facebook_page.json'
  end
  
  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end