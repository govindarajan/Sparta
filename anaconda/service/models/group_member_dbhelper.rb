require File.dirname(__FILE__) + '/anaconda.rb'
require File.dirname(__FILE__) + '/anaconda_dbhelper.rb'

class GroupMemberDbHelper < AnacondaDbHelper

  @@g_mems = GroupMemberModel.dataset()

  def self.create(g_id, phone)
    insert_params = Hash.new
    throw "Missing Params " if (g_id.nil? || phone.nil?)

    insert_params[:group_id] = g_id
    insert_params[:phone] = phone
    
    lam = lambda { @@g_mems.insert_ignore.multi_insert([insert_params]) }
    invoke(lam)
    get_by_phone(phone)
  end

  def self.delete(id)
    GroupMemberModel.where({:id => id}).delete
  end

  def self.get_by_phone(phone)
    predicate = { :phone => phone }
    mems = GroupMemberModel
      .where(predicate)
      .limit(1)
      .all

    return nil if mems.nil? || mems.first.values.nil?
    mems.first.values
  end

  def self.get_active_members(gid)
    predicate = { :group_id => gid, :active => 1 }
    mems = GroupMemberModel
      .where(predicate)
      .all

    return [] if mems.nil?
    mems.map { |mem|
      mem.values
    }
  end

end
