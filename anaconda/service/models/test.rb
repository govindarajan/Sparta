require File.dirname(__FILE__) + '/user_dbhelper.rb'

p = Hash.new
p[:id] = "123"
p[:name] = "Govind"
p[:phone_number] = "08050103381"
p[:token] = "tokererererere"
r = UserDbHelper.create_update(p);
print "Res 1 : #{r.inspect}"
