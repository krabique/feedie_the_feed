require 'sinatra/base'

class FakeFacebook < Sinatra::Base
  # Logging for debugging (uncomment on demand)
  # configure :production, :development do
  #   enable :logging
  # end

  get '/ruby.programming/posts' do
    json_response 200, 'facebook_page.json'
  end

  post '/oauth/access_token' do
    request.body.rewind # in case someone already read it
    if request.body.read =~ /client_id=bad_appid.*client_secret=bad_secret/
      json_response 400, 'unvalid_facebook_credentials.json'
    else
      json_response 190, 'facebook_oauth.json'
    end
  end

  get '/not_existing_page/posts' do
    json_response 401, 'unvalid_facebook_page.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
