require 'rest_client'
require 'json'
class GeoCoder

	def self.getAddress(lat, long)
		request = "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{lat},#{long}&key=AIzaSyDwLFfHzK5dfLO8ZpVc9URii05Lnntnyhk"
		result = JSON.parse(RestClient.get(request))
		result["results"][0]["formatted_address"]
	end
end

##GeoCoder::getAddress("40.714224", "-73.961452")
