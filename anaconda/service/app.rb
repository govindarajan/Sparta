require 'sinatra'
require 'json'

require_relative 'helpers/common_helper'
require File.dirname(__FILE__) + '/controllers/register.rb'
require File.dirname(__FILE__) + '/controllers/groups.rb'

class AnacondaService < Sinatra::Base

  helpers Anaconda::Helpers::CommonHelper
  
  get '/' do
    return "Who the hell are you!!"
  end
  
  get '/calls' do
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

end
