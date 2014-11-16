
class RestError < StandardError

  attr_reader :http_code, :message

  def initialize(http_code, message = nil)
    @http_code = http_code || 500
    @message = message || "Internal Server Error"
  end
end

class AuthError < RestError
end
