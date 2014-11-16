require File.dirname(__FILE__) + '/anaconda.rb'
require File.dirname(__FILE__) + '/anaconda_dbhelper.rb'

class UserDbHelper < AnacondaDbHelper

  @@users = UserModel.dataset()

  def self.create_update(params)
    insert_params = Hash.new
    {
      :id => :mandatory,
      :name => :mandatory,
      :phone_number => :mandatory,
      :token => :mandatory,
    }.each do |param, value|
      throw "Missing Parameter [#{param}] for creating event" if
        (value == :mandatory && !params.key?(param))
      insert_params[param] = params[param] if params.key?(param)
    end
    normalize insert_params
    
    lam = lambda { @@users.on_duplicate_key_update.insert(insert_params) }
    invoke(lam)
    get(params[:id])
  end

  def self.get(id)
    predicate = { :id => id }
    users = UserModel
      .where(predicate)
      .all

    return nil if users.nil? || users.first.nil?
    user = users.first.values
    denormalize user
    user
  end

  def self.get_all()
    users = UserModel
      .all

    return [] if users.nil? 
    users.map { |user|
      user.values
    }
  end

  private

  def self.normalize(insert_params)
    insert_params
  end

  def self.denormalize(user)
    user
  end
end
