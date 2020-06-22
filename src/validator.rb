require_relative './exceptions'

class Validator
  REQUIRED_GET_PARAMS = "(from, to) or route"
  REQUIRED_POST_PARAMS = "from, to and value"

  def self.validate_params_presence(params)
    if (params[:from].nil? || params[:to].nil?) && params[:route].nil?
      raise MissingParamsException.new(REQUIRED_GET_PARAMS)
    end
  end

  def self.validate_vertices_presence(vertices, to_check)
    to_check.each do | vertex |
      unless vertices.include? vertex
        raise VertexNotFoundException.new(vertex)
      end
    end
    return nil
  end

  def self.validate_payload(params)
    if params["from"].nil? || params["to"].nil? || params["value"].nil?
      raise MissingParamsException.new(REQUIRED_POST_PARAMS)
    end
  end
end
