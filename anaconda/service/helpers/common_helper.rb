require File.dirname(__FILE__) + '/../models/user_dbhelper.rb'

module Anaconda
  module Helpers
    module CommonHelper
      def json_response(success, code, message, data)
        hash_response(success, code, message, data).to_json
      end

      def hash_response(success, code, message, data)
        response = Hash.new
        response[:success] = success
        response[:code] = code
        response[:message] = message
        response[:data] = data
        response
      end

      def common_auth_exec(&block)
        begin
          auth!
          data = block.call
          json_response(true, 200, nil, data)
        rescue AuthError => authEx
          status authEx.http_code
          message = authEx.message.nil? ? 'Internal Service Error During Auth' : authEx.message
          json_response(false, 401,  message, nil)
        rescue RestError => rEx
          code = rEx.http_code
          message = rEx.message.nil? ? 'Internal Service Error' : rEx.message
          json_response(false, code,  message, nil)
        rescue => ex
          print ex.message
          print ex.backtrace
          message = "Internal Service Error"
          json_response(false, 500, message, nil)
        end
      end

      def auth!
        auth ||=  Rack::Auth::Basic::Request.new(request.env)
        raise AuthError.new(401, "Authentication is not provided.") if auth.provided? == false
        user_id, token = auth.credentials
        @user_id = user_id
        user = UserDbHelper.get(user_id)
        raise AuthError.new(401, "Invalid auth provided") if (user.nil? || user[:id] != user_id || token != user[:token])
      end

    end
  end
end
