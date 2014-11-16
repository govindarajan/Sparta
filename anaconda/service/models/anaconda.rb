require 'sequel'
require 'mysql'

Sequel.datetime_class = DateTime

db_user = "haha"
db_password = "fromHackaDon"
db_host = "127.0.0.1"
db_port =  3306
db_name = "anaconda"
conn_str = "mysql://#{db_user}:#{db_password}@#{db_host}:#{db_port}/#{db_name}"
db = Sequel.connect(conn_str)

class UserModel < Sequel::Model(db[:users])
  unrestrict_primary_key
  set_primary_key [:id]
  @use_transactions = false
end

class MappingModel < Sequel::Model(db[:mapping])
  unrestrict_primary_key
  set_primary_key [:sid]
  @use_transactions = false
end

class TransDbModel < Sequel::Model(db[:trans_data])
  unrestrict_primary_key
  set_primary_key [:id]
  @use_transactions = false
end

class GroupModel < Sequel::Model(db[:groups])
  unrestrict_primary_key
  set_primary_key [:id]
  @use_transactions = false
end

class GroupMemberModel < Sequel::Model(db[:group_members])
  unrestrict_primary_key
  set_primary_key [:id]
  @use_transactions = false
end

class UserDataModel < Sequel::Model(db[:user_data])
  unrestrict_primary_key
  set_primary_key [:id]
  @use_transactions = false

  def before_create
    super
    # Change the activity_time to mysql supported params
    self.date_created ||= Time.now.strftime("%Y-%m-%d %H:%M:%S") 
    self.date_created = DateTime.parse(self.date_created).strftime("%Y-%m-%d %H:%M:%S")
  end

end
