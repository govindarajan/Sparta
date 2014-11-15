require File.dirname(__FILE__) + '/anaconda.rb'
require File.dirname(__FILE__) + '/anaconda_dbhelper.rb'

class UserDataDbHelper < AnacondaDbHelper

  @@u_data = UserDataModel.dataset()

  def self.create(uid, data)
    insert_params = Hash.new
    throw "Missing Params " if (uid.nil? || data.nil?)

    insert_params[:user_id] = uid
    insert_params[:data] = data
    insert_params[:date_created] = Time.now.strftime("%Y-%m-%d %H:%M:%S") 

    normalize insert_params

    lam = lambda { @@u_data.insert(insert_params) }
    invoke(lam)
  end

  def self.get_last_user_data(uid)
    predicate = { :user_id => uid }
    udata = UserDataModel
      .where(predicate)
      .order(Sequel.desc(:date_created))
      .limit(1)
      .all

    return nil if udata.nil?
    udat = udata.first.values
    udat = denormalize udat
    udat
  end

  private

  def self.normalize insert_params
    insert_params[:date_created] = DateTime.parse(insert_params[:date_created]).strftime("%Y-%m-%d %H:%M:%S")
    insert_params[:data] = insert_params[:data].to_json if insert_params[:data].is_a?(Hash)
    insert_params
  end

  def self.denormalize u_data
    u_data[:date_created] = u_data[:date_created].strftime("%FT%TZ")
    u_data[:data] = JSON.parse(u_data[:data], { :symbolize_names => true }) unless u_data[:data].nil?
    u_data
  end

end
