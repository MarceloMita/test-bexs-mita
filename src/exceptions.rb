class Exceptions < Exception
  attr_accessor :message, :status

  BAD_REQUEST = 400
  NOT_FOUND = 404
  UNPROCESSABLE_ENTITY = 422


  def initialize(status, message)
    self.status = status || 500
    self.message = message || "Ops, it has occurred an error. Please contact support"
  end
end

class VertexNotFoundException < Exceptions
  def initialize(vertex)
    super(NOT_FOUND, "#{vertex} is not in the list of available vertices")
  end
end

class MissingParamsException < Exceptions
  def initialize(params)
    super(BAD_REQUEST, "Params: [#{params}] are required")
  end
end

class UnprocessableEntityException < Exceptions
  def initialize(params)
    super(UNPROCESSABLE_ENTITY, "Could not process request with params: #{ params.to_s }")
  end
end

class VertexNotReachableException < Exceptions
  def initialize(to)
    super(UNPROCESSABLE_ENTITY, "Vertex #{to} not reachable")
  end
end
