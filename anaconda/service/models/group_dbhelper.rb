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
    get_by_name(insert_params[:name], insert_params[:user_id])
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

  def self.get_by_name(name, uid)
    predicate = { :name => name, :user_id => uid }
    groups = GroupModel
      .where(predicate)
      .limit(1)
      .all

    return nil if groups.nil? || groups.first.nil?
    group = groups.first.values
    group

  end

  def self.get_by_uid(uid)
    predicate = { :user_id => uid }
    groups = GroupModel
      .where(predicate)
      .all

    return [] if groups.nil?
    groups.map { |group|
      group.values
    }
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
