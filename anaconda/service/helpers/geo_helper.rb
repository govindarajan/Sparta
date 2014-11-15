require 'rest_client'
require 'json'
class GeoCoder

	def self.getAddress(lat, long)
		request = "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{lat},#{long}&key=AIzaSyDwLFfHzK5dfLO8ZpVc9URii05Lnntnyhk"
		result = JSON.parse(RestClient.get(request))
		result["results"][0]["formatted_address"]
	end

	def self.getNearestUsers(lat1, long1, lat2, long2, distance)
		if (Math.acos(Math.sin(lat1.to_f) * Math.sin(lat2.to_f) + Math.cos(lat1.to_f) * Math.cos(lat2.to_f) * Math.cos(long2.to_f - (long1.to_f))) * 6371 <= distance.to_f)
			return true;
		end
		return false;
	end
end

##GeoCoder::getAddress("40.714224", "-73.961452")
#lat1="12.9715987"
#long1="77.59456269999998"
#lat2="12.969948"
#long2 ="77.6096663999999" 
#distance = 100
#p GeoCoder::getNearestUsers(lat1, long1, lat2, long2, distance)

