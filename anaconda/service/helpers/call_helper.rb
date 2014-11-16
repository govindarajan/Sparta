require 'rest_client'
require 'exotel'
class CallHelper
	def initialize
  		@exotel_sid   = "test4"
  		@exotel_token = "9e22af6a705e22840d769d06b041be59092af39f"
		@url = "https://#{@exotel_sid}:#{@exotel_token}@twilix.exotel.in/v1/Accounts/#{@exotel_sid}/Calls/connect" 
		Exotel.configure do |c|
  			c.exotel_sid   = "test4"
  			c.exotel_token = "9e22af6a705e22840d769d06b041be59092af39f"
		end
	end

	def initiateCall(number)
		vn = "02230770124"
		response = Exotel::Call.connect_to_flow(:to => number, :from => vn, :caller_id => vn, :call_type => 'trans', :flow_id => '31645')
		call_id = response.sid #sid is used to find the details of the call. Ex: Total price of teh call. 
	end
end


#sampleUsage
#call_helper = CallHelper.new
#call_helper.initiateCall("08050103381")
