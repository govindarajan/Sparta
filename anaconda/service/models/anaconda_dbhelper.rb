class AnacondaDbHelperError < StandardError
  attr_reader :fatal

  def initialize(is_fatal, message = nil)
    super(message)
    @fatal = is_fatal
  end

  def fatal?
    return @fatal
  end
end

# Class to execute queries and handle/raise all DB exception

class AnacondaDbHelper
  
  def self.invoke(l)
    begin
      raise "Expeceted parameter[lambda] is not given." unless l.is_a? Proc
      l.call
    rescue Sequel::UniqueConstraintViolation => ucv_ex
      # Unique key error. This is a fatal error.
      raise AnacondaDbHelperError.new(true, ucv_ex.message)
    rescue Sequel::ConstraintViolation => cv_ex
      # Generic constraint violation. This is also a fatal error.
      raise AnacondaDbHelperError.new(true, cv_ex.message)
    rescue Sequel::SerializationFailure => sf_ex
      # Serialization failure/deadlock in the database.
      raise AnacondaDbHelperError.new(true, sf_ex.message)
    rescue Sequel::DatabaseDisconnectError => dde_ex
      # Raised when the connection to the database has been lost. This is non-fatal.
      raise AnacondaDbHelperError.new(false, dde_ex.message)
    rescue Sequel::DatabaseError => de_ex
      # This is generic sequel DB error.. Lets make this as a temp failure
      raise AnacondaDbHelperError.new(false, de_ex.message)
    end
  end
  
end
