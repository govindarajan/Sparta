require File.dirname(__FILE__) + '/anaconda.rb'
require File.dirname(__FILE__) + '/anaconda_dbhelper.rb'

class TransDbHelper < AnacondaDbHelper

  @@trans= TransDbModel.dataset()

  def self.create_update(params)
    lam = lambda { @@trans.on_duplicate_key_update.insert(params) }
    invoke(lam)
  end

  def self.get(id)
    predicate = { :id => id }
    users = TransDbModel 
      .where(predicate)
      .first
    return nil if users.nil? || users.first.nil?
    users
  end

  private

end
