require 'sinatra'
require 'json'

require_relative 'helpers/common_helper'
require File.dirname(__FILE__) + '/controllers/register.rb'
require File.dirname(__FILE__) + '/controllers/groups.rb'
require File.dirname(__FILE__) + '/models/user_dbhelper.rb'
require File.dirname(__FILE__) + '/models/group_member_dbhelper.rb'
require File.dirname(__FILE__) + '/helpers/call_helper.rb'
require File.dirname(__FILE__) + '/models/trans_datahelper.rb'
require File.dirname(__FILE__) + '/models/mapping_dbhelper.rb'

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

  post '/alert' do
    common_auth_exec {
      #This needs the following params 
      #number, lat, long, type, user_id is assumed to be alert.
      user = UserDbHelper.get(@user_id)
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
      params1 = {:flow_id => 31645, :user_id => @user_id, :date_created => Time.now}
      id = TransDbHelper.create_update(params1)
      #TODO send sms, get memebers within 10 kms , to all of them, create sms content with this tran id and send sms.
      # 1. Get all the users
      # 2. if this user is with in 5km range, add it to the list.
      # 3. Get only 5 people from this list and send SMS to those people with the transaction id
      cur_user = UserDataDbHelper.get_last_user_data(@user_id)
      cur_user_data = JSON.parse(cur_user[:data], { :symbolize_names => true }) unless cur_user_data.nil?
      cur_user_loc = cur_user_data[:location]
      nearby_users = []
      users = UserDbHelper.get_all()
      users.each do |user|
        if user[:id] == @user_id
          next
        end
        udata = UserDataDbHelper.get_last_user_data(user[:id])
        if (udata != nil && udata[:data] != nil)
          data = JSON.parse(udata[:data], { :symbolize_names => true })
          loc = data[:location]
          if (GeoCoder::getNearestUsers(cur_user_loc, loc, 5))
            u = UserDbHelper.get(udata[:user_id])
            nearby_users << u[:phone_number] unless u.nil?
          end
        end
      end

      # Get res around 1000m
      nearby_res = GeoCoder::get_nearest_place(cur_user_loc, 1000)
      sms_content = "";
      nearby_res.each do |k, v|
        sms_content += "#{v[:name]} : #{v[:address]}\n"
      end
      GeoCoder::smsMembers(nearby_users, sms_content)
      return {:message =>"inserted", :trans_id => id}.to_json
    }
  end
  
  get '/incoming' do
    trans_id = params[:digits] 
    from = params[:From]
    trans = TransDbHelper.get(trans_id)
    return {:error => true, :message => "No tran for this"}.to_json if trans.nil?
    user = UserDbHelper.get(trans[:user_id])
    mapping_params = {:sid => params[:CallSid], :from => params[:From], :to => user[:phone_number]}
    MappingDbHelper.create_update(mapping_params)
    return {:message =>"inserted", :trans_id => trans_id}.to_json
  end

  get '/connectnumber' do
    mapping = MappingDbHelper.get(params[:CallSid])
    return "" if mapping.nil?
    return mapping[:to]
  end


end
