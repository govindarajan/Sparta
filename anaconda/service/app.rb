require 'sinatra'
require 'oauth2'
require 'json'

require File.dirname(__FILE__) + '/controllers/register.rb'
require File.dirname(__FILE__) + '/helpers/common_helper.rb'
class Anaconda < Sinatra::Base 
  get '/' do
    return "Who the hell are you!!"
  end
  
  get "/auth" do
    p "HEyyyyyyyyyyyyyyyyy"
  end

  get '/calls' do
  end

  post '/register' do
    begin
      data = UserController.new.register(request.body.read)
      CommonHelper.json_response(true, 200, nil, data)
    rescue => ex
      print ex.message
      print ex.backtrace
      CommonHelper.json_response(false, 500, "Internal Server Error", nil)
    end
  end
  
  def redirect_uri
    'http://asterisk.exotel.in:9292/oauth2callback'
  end
end
