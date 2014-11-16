require 'sinatra'
require 'oauth2'
require 'json'
require 'service/models/user_dbhelper.rb'
 
 
 
get '/' do
  erb :index
end
 
get "/auth" do
    p "HEyyyyyyyyyyyyyyyyy"
end

post '/alert' do
	#This needs the following params 
	#number, lat, long, type, user_id is assumed to be alert.
	user = UserDbHelper.get(user_id)
	if user.nil?
		return {:error => true, :message => "The user does not exist"}.to_json
	end
	group = GroupDbHelper.get_by_userid(user_id)
	unless group.nil?
		#Initiate call to all the members in that group.
		members = []
		members << GroupMemberDbHelper.get_active_members(group.first.id)
	end

		
end

 
def redirect_uri
  'http://asterisk.exotel.in:9292/oauth2callback'
end
