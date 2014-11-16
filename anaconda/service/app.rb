require 'sinatra'
require 'json'

require_relative 'helpers/common_helper'
require File.dirname(__FILE__) + '/controllers/register.rb'
require File.dirname(__FILE__) + '/controllers/groups.rb'
require File.dirname(__FILE__) + '/models/user_dbhelper.rb'
require File.dirname(__FILE__) + '/models/group_member_dbhelper.rb'
require File.dirname(__FILE__) + '/helpers/call_helper.rb'
require File.dirname(__FILE__) + '/models/trans_datahelper.rb'

class AnacondaService < Sinatra::Base

  helpers Anaconda::Helpers::CommonHelper
  
  get '/' do
    return "Who the hell are you!!"
  end

  get '/missedCall' do
      return "hey"
  end
  
  post '/register' do
    begin
      data = UserController.new.register(request.body.read)
      json_response(true, 200, nil, data)
    rescue => ex
      print ex.message
      print ex.backtrace
      json_response(false, 500, "Internal Server Error", nil)
    end
  end

  post '/location' do
    common_auth_exec {
      UserController.new.update_location(request.body.read, @user_id)
    }
  end

  post '/groups' do
    common_auth_exec {
      GroupController.new.create_group(request.body.read, @user_id)
    }
  end

  get '/groups' do
    common_auth_exec {
      GroupController.new.get_groups(@user_id)
    }
  end

  post '/groupusers/:gid' do
    common_auth_exec {
      GroupController.new.add_member(request.body.read, params[:gid], @user_id)
    }
  end

  get '/groupusers/:gid' do
    common_auth_exec {
      GroupController.new.get_group_members(params[:gid], @user_id)
    }
  end

  delete '/groupusers/:gid/:id' do
    common_auth_exec {
      GroupController.new.delete_member(params[:id], params[:gid], @user_id)
    }
  end

 post '/alert/:id' do
    #This needs the following params 
    #number, lat, long, type, user_id is assumed to be alert.
        user = UserDbHelper.get(params[:id])
        if user.nil?
           return {:error => true, :message => "The user does not exist"}.to_json
        end
        #group = GroupDbHelper.get_by_userid(params[:id])
        #unless group.nil?
         #   #Initiate call to all the members in that group.
          #  numbers = []
         #   members = GroupMemberDbHelper.get_active_members(group.first.id)
    #members.each do |member| 	
    #numbers << member[:phone] 
    #end
    #call_helper = CallHelper.new
    #call_helper.callMembers(numbers, 31645)
    #Create a new transaction with this user.
    params1 = {:flow_id => 31645, :user_id => params[:id], :date_created => Time.now}
    id = TransDbHelper.create_update(params1)
    return {:message =>"inserted", :trans_id => id}.to_json
 end
  
 get '/incoming' do
    p params
    trans_id = params[:digits] 
    from = params[:From]
    #trans = TransDbHelper.get(trans_id)
    numbers = [] #TODO fetch it from DB
    numbers << from
    json = {:numbers => numbers}.to_json
    params = {:data => json, :id=> trans_id}
    id = TransDbHelper.create_update(params) 
    p id
    return {:message =>"inserted", :trans_id => trans_id}.to_json
 end


end
