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

	def initiateCall(from, to)
		vn = "08033545128"
		response = Exotel::Call.connect_to_flow(:to => to, :from => from, :caller_id => vn, :call_type => 'trans')
		response.sid #sid is used to find the details of the call. Ex: Total price of teh call. 
	end
	
	def callMembers(numbers, flow_id)
		sids = []
		numbers.each do |number|
			sid = initiateCall(number, flow_id)
			sids << sid unless sid.nil?
		end
		sids
	end

	def sendSms(number, content)
		vn = "09222183143"
		response = Exotel::Sms.send(:from => vn, :to => number, :body => content)
		response.sid #sid is used to find the details of the call. Ex: Total price of teh call. 
	end

	def smsMembers(numbers, content)
		sids = []
		numbers.each do |number|
			sid = sendSms(number, content)
			sids << sid unless sid.nil?
		end
		sids
	end
end


#sampleUsage
#call_helper = CallHelper.new
#call_helper.initiateCall("08050103381")
