require File.dirname(__FILE__) + '/anaconda.rb'
require File.dirname(__FILE__) + '/anaconda_dbhelper.rb'

class GroupDbHelper < AnacondaDbHelper

  @@groups = GroupModel.dataset()

  def self.create(name, type, user_id)
    insert_params = Hash.new
    throw "Missing Params " if (name.nil? || type.nil? || user_id.nil?)

    insert_params[:name] = name
    insert_params[:type] = type
    insert_params[:user_id] = user_id
    
    lam = lambda { @@groups.insert(insert_params) }
    invoke(lam)
  end

  def self.get(id)
    predicate = { :id => id }
    groups = GroupModel
      .where(predicate)
      .all

    return nil if groups.nil? || groups.first.nil?
    group = groups.first.values
    group
  end

  def self.get_by_userid(user_id, type = nil)
    predicate = { :user_id => user_id }
    predicate[:type] = type unless type.nil?
    groups = GroupModel
      .where(predicate)
      .all

    return nil if groups.nil?
    groups
  end

end
