require 'rest_client'
require 'json'
require 'cgi'

class GeoCoder
  @@key = "AIzaSyDkAgOadXOWcWqrK-sGx3SN0fEzrSZAsIw"

  def self.getAddress(lat, long)
    request = "https://maps.googleapis.com/maps/api/geocode/json?latlng=#{lat},#{long}&key=#{@@key}"
    result = JSON.parse(RestClient.get(request))
    result["results"][0]["formatted_address"]
  end

  def self.getNearestUsers(lat1, long1, lat2, long2, distance)
    if (Math.acos(Math.sin(lat1.to_f) * Math.sin(lat2.to_f) + Math.cos(lat1.to_f) * Math.cos(lat2.to_f) * Math.cos(long2.to_f - (long1.to_f))) * 6371 <= distance.to_f)
      return true;
    end
    return false;
  end

  def self.get_nearest_place(loc, radius, type = "food|night_club|meal_delivery|meal_takeaway")
    types = CGI::escape(type)
    request = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{loc}&radius=#{radius}&key=#{@@key}&types=#{types}"
    result = JSON.parse(RestClient.get(request), { :symbolize_names => true })
    top_result = {}
    i = 0
    result[:results].each do |result|
      r = {}
      r[:name] = result[:name]
      r[:rating] = result[:rating]
      r[:address] = result[:vicinity]
      if (i < 5)
         top_result[i] = r
      end
      i += 1
    end
    top_result
  end

end

##GeoCoder::getAddress("40.714224", "-73.961452")
#lat1="12.9715987"
#long1="77.59456269999998"
#lat2="12.969948"
#long2 ="77.6096663999999"
#distance = 100
#p GeoCoder::getNearestUsers(lat1, long1, lat2, long2, distance)
#p GeoCoder::get_nearest_place("12.967615,77.641123", 500);

