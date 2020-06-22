require 'rspec'

require_relative '../src/route'
require_relative './route_factory'

describe 'Route' do
  describe '#get_edges' do
    it 'constructs hash map that represents file graph' do
      edges = Route.get_edges(Route::INPUT_FILE)
      expect(edges).to eq(EXPECTED_EDGES)
    end
  end

  describe '#extract_vertices' do
    it 'returns all vertices on graph' do
      vertices = Route.extract_vertices(EXPECTED_EDGES)
      expect(vertices).to eq(EXPECTED_VERTICES)
    end
  end

  describe '#best_route_string' do
    before(:each) do
      @prev = { 'a' => nil, 'b' => 'a', 'c' => 'b' }
      @to = 'c'
      @values = { 'c' => 10 }
    end

    it 'returns the best route string generated from prev hashmap' do
      expect(Route.best_route_string(@values, @prev, @to)).to eq('a - b - c > 10')
    end

    it 'throws a VertexNotReachableException if vertex is not reachable' do
      begin
        Route.best_route_string(@values, @prev, 'a')
        fail('Should have thrown an VertexNotReachableException')
      rescue VertexNotReachableException => e
        expect(e.message).to eq('Vertex a not reachable')
      end
    end
  end

  describe '#get_minimum_distance_vertex' do
    it 'returns the vertex in vertices array that has the minimum distance to from vertex' do
      values = { 'a' => 5, 'b' => -1, 'c' => 2 }
      vertices = %w(a b c)

      expect(Route.get_minimum_distance_vertex(vertices, values)).to eq('c')
    end
  end

  describe '#find_best_route' do
    it 'returns best route from a to c' do
      expect(Route.find_best_route('a', 'c')).to eq('a - b - c > 15')
    end

    it 'returns no cost when from is equal to to' do
      expect(Route.find_best_route('a', 'a')).to eq('a > 0')
    end

    it 'throws a VertexNotFoundException when `from` is not a valid node' do
      begin
        Route.find_best_route('f', 'c')
        fail('Should have thrown an VertexNotFoundException')
      rescue VertexNotFoundException => e
        expect(e.message).to eq('f is not in the list of available vertices')
      end
    end

    it 'throws a VertexNotFoundException when `to` is not a valid node' do
      begin
        Route.find_best_route('a', 'g')
        fail('Should have thrown an VertexNotFoundException')
      rescue VertexNotFoundException => e
        expect(e.message).to eq('g is not in the list of available vertices')
      end
    end
  end

  describe '#best_route' do
    it 'returns best route from a to c using from, to params' do
      expect(Route.best_route({from: 'a', to:'c'})).to eq('a - b - c > 15')
    end

    it 'returns best route from a to c using route param' do
      expect(Route.best_route({route: 'a-c'})).to eq('a - b - c > 15')
    end
  end
end