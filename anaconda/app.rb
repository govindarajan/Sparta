require 'sinatra'
require 'oauth2'
require 'json'
 
 
 
get '/' do
  erb :index
end
 
get "/auth" do
    p "HEyyyyyyyyyyyyyyyyy"
end

get '/calls' do
end

 
def redirect_uri
  'http://asterisk.exotel.in:9292/oauth2callback'
end
