require File.dirname(__FILE__) + '/anaconda.rb'
require File.dirname(__FILE__) + '/anaconda_dbhelper.rb'

class GroupMemberDbHelper < AnacondaDbHelper

  @@g_mems = GroupMemberModel.dataset()

  def self.create(g_id, phone)
    insert_params = Hash.new
    throw "Missing Params " if (g_id.nil? || phone.nil?)

    insert_params[:group_id] = g_id
    insert_params[:phone] = phone
    
    lam = lambda { @@g_mems.insert(insert_params) }
    invoke(lam)
  end

  def serf.get_active_members(gid)
    predicate = { :group_id => gid, :active => 1 }
    mems = GroupMemberModel
      .where(predicate)
      .all

    return nil if mems.nil?
    mems
  end

end
