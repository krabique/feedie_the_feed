require 'sinatra/base'

class FakeFacebook < Sinatra::Base
  get '/ruby.programming' do
    json_response 200, 'facebook_page.json'
  end

  get '/oauth/access_token' do
    json_response 190, 'unvalid_facebook_credentials.json'
  end

  get '/not_existing_page' do
    json_response 200, 'unvalid_facebook_page.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
