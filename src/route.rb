require_relative './validator'

require 'byebug'

class Route
  INFINITY = -1
  INPUT_FILE = ENV['STAGE'] == 'test' ? 'spec/input-routes.csv' : 'src/input-routes.csv'
  INPUT_BKP_FILE = ENV['STAGE'] == 'test' ? 'spec/input-bkp.csv' : 'src/input-bkp.csv'

  def self.best_route(params)
    if params[:route]
      from, to = params[:route].strip.split('-')
    else
      from = params[:from]
      to = params[:to]
    end
    find_best_route(from, to)
  end

  def self.find_best_route(from, to)
    return "#{from} > 0" if from == to
    edges = get_edges(INPUT_FILE)
    vertices = extract_vertices(edges)
    Validator.validate_vertices_presence(vertices, [from, to])
    values = {}
    prev = {}

    vertices.each do |vertex|
      values[vertex] = INFINITY
      prev[vertex] = nil
    end
    values[from] = 0
    until vertices.empty?
      vertex = get_minimum_distance_vertex(vertices, values)
      break if vertex.nil? || vertex == to
      vertices.delete(vertex)

      edges.select { |edge| edge[:from] == vertex }.each do |edge|
        val = values[vertex] == INFINITY ? edge[value] : values[vertex] + edge[:value]
        if values[edge[:to]] == INFINITY || val < values[edge[:to]]
          values[edge[:to]] = val
          prev[edge[:to]] = vertex
        end
      end
    end
    best_route_string(values, prev, to)
  end

  def self.get_edges(input_file)
    lines = IO.readlines(input_file)
    edges = []
    lines.each do |line|
      from, to, value = line.split(',')
      value = value.to_i
      edges << { from: from, to: to, value: value }
    end
    edges
  end

  def self.extract_vertices(edges)
    vertices = []
    edges.each do |edge|
      vertices << edge[:from]
      vertices << edge[:to]
    end
    vertices.uniq
  end

  def self.get_minimum_distance_vertex(vertices, values)
    vertex = nil
    vertices.each do |v|
      vertex = v if values[v] != INFINITY && (vertex.nil? || values[v] <= values[vertex])
    end

    vertex
  end

  def self.best_route_string(values, prev, to)
    raise VertexNotReachableException.new(to) if prev[to].nil?
    str = to
    lst = to
    while !prev[lst].nil?
      str = "#{ prev[lst] } - #{ str }"
      lst = prev[lst]
    end
    "#{str} > #{values[to]}"
  end

  def self.create_edge(from, to, value)
    edges = get_edges(INPUT_FILE)
    edge = edges.select { |e| e[:from] == from && e[:to] == to }.first
    if edge.nil?
      edge = { from: from, to: to }
      edges << edge
    end
    edge[:value] = value
    rewrite_input_file(edges)
  end

  def self.rewrite_input_file(edges)
    FileUtils.cp(INPUT_FILE, INPUT_BKP_FILE)
    begin
      File.open(INPUT_FILE, 'w') {|file| file.truncate(0) }
      File.open(INPUT_FILE, 'a') do |file|
        edges.each do |edge|
          file.puts "#{edge[:from]},#{edge[:to]},#{edge[:value]}"
        end
      end
      File.delete(INPUT_BKP_FILE)
      true
    rescue
      # Restore file
      FileUtils.cp(INPUT_BKP_FILE, INPUT_FILE)
      File.delete(INPUT_BKP_FILE)
      false
    end
  end
end
