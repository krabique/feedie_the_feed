require 'sinatra/base'

class FakeRSS < Sinatra::Base
  get '/rss' do
    xml_response 200, 'rss_page.xml'
  end

  private

  def xml_response(response_code, file_name)
    content_type :xml
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
