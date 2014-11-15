require File.dirname(__FILE__) + '/../models/group_dbhelper.rb'
require File.dirname(__FILE__) + '/../models/group_member_dbhelper.rb'
require File.dirname(__FILE__) + '/../helpers/errors.rb'
require 'json'

class GroupController
  def create_group(qp, uid)
    params = validate_cg(qp)
    data = GroupDbHelper.create(params[:name], params[:type], uid)
    data
  end

  def get_groups(uid)
    data = GroupDbHelper.get_by_uid(uid)
    data
  end

  def get_group_members(gid, uid)
    # Check if the group id is belongs to him.
    group = GroupDbHelper.get(gid)
    raise RestError.new(403, "You dont have access to this page.") if group[:user_id] != uid
    GroupMemberDbHelper.get_active_members(gid)
  end

  def delete_member(id, gid, uid)
    group = GroupDbHelper.get(gid)
    raise RestError.new(403, "You dont have access to this page.") if group[:user_id] != uid
    GroupMemberDbHelper.delete(id)
  end

  def add_member(qb, gid, uid)
    raise RestError.new(400, "Missing params.") if qb.nil?
    params = JSON.parse qb, { :symbolize_names => true }
    raise RestError.new(400, "Missing Params..") if params[:phone].nil?

    # Check if the group id is belongs to him.
    group = GroupDbHelper.get(gid)
    raise RestError.new(403, "You dont have access to this page.") if group[:user_id] != uid
    GroupMemberDbHelper.create(gid, params[:phone])
  end

  def validate_cg(query)
    raise RestError.new(400, "Mandatory params are missing") if query.nil?
    params = JSON.parse query, { :symbolize_names => true }
    [
     :name,
     :type,
    ].each { |param|
      raise RestError.new(400, "Mandatory params are missing.") unless params.key?(param)
    }
    params
  end

end
