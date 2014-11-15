class CommonHelper
  def self.json_response(success, code, message, data)
    hash_response(success, code, message, data).to_json
  end

  def self.hash_response(success, code, message, data)
    response = Hash.new
    response[:success] = success
    response[:code] = code
    response[:message] = message
    response[:data] = data
    response
  end

end
