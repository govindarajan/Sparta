require File.dirname(__FILE__) + '/../models/user_dbhelper.rb'
require File.dirname(__FILE__) + '/../models/user_data_dbhelper.rb'
require File.dirname(__FILE__) + '/../helpers/errors.rb'
require 'json'
require 'digest'

class UserController
  def register(qp)
    params = validate_reg(qp)
    iparams = Hash.new
    iparams[:name] = params[:name]
    iparams[:phone_number] = params[:phone_number]
    iparams[:token] = params[:token]
    iparams[:id] = Digest::MD5.hexdigest(params[:phone_number])
    loc = params[:location]
    UserDbHelper.create_update(iparams)
    data = Hash.new
    data[:location] = loc
    UserDataDbHelper.create(iparams[:id], data)
    UserDbHelper.get(iparams[:id])
  end

  def validate_reg(query)
    print "#### #{query.inspect}"
    throw RestError.new(400, "Mandatory params are missing") if query.nil?
    params = JSON.parse query, { :symbolize_names => true }
    [
     :name,
     :phone_number,
     :token,
     :location
    ].each { |param|
      raise RestError.new(400, "Mandatory params are missing.") unless params.key?(param)
    }
    params
  end
end

