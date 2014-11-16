require File.dirname(__FILE__) + '/anaconda.rb'
require File.dirname(__FILE__) + '/anaconda_dbhelper.rb'

class MappingDbHelper < AnacondaDbHelper

  @@trans= MappingModel.dataset()

  def self.create_update(params)
    p params
    lam = lambda { @@trans.on_duplicate_key_update.insert(params) }
    invoke(lam)
  end

  def self.get(id)
    predicate = { :sid => id }
    users = MappingModel 
      .where(predicate)
      .first
    return nil if users.nil? || users.first.nil?
    users
  end

  private

end
