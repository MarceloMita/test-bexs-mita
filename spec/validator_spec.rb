require 'rspec'

require_relative '../src/validator'

describe 'Validator' do
  context '#validate_params_presence' do
    it 'throws exception when missing from & route params' do
      begin
        Validator.validate_params_presence({ to: 'a' })
        fail('Should have thrown an MissingParamsException')
      rescue MissingParamsException => e
        expect(e.message).to eq('Params: [(from, to) or route] are required')
      end
    end

    it 'throws exception when missing to & route params' do
      begin
        Validator.validate_params_presence({ from: 'a' })
        fail('Should have thrown an MissingParamsException')
      rescue MissingParamsException => e
        expect(e.message).to eq('Params: [(from, to) or route] are required')
      end
    end

    it 'throws exception when params are passed' do
      begin
        Validator.validate_params_presence({})
        fail('Should have thrown an MissingParamsException')
      rescue MissingParamsException => e
        expect(e.message).to eq('Params: [(from, to) or route] are required')
      end
    end

    it 'doesn`t throw any exception when receive from and to parameters' do
      expect(Validator.validate_params_presence({ from: 'a', to: 'c' })).to be_nil
    end

    it 'doesn`t throw any exception when receive route parameter' do
      expect(Validator.validate_params_presence({ route: 'a-c' })).to be_nil
    end
  end

  context '#validate_vertices_presence' do
    it 'throws a VertexNotFoundException when vertex is not presence in the graph' do
      begin
        Validator.validate_vertices_presence(%w(a b), %w(c))
        fail('Should have thrown an VertexNotFoundException')
      rescue VertexNotFoundException => e
        expect(e.message).to eq('c is not in the list of available vertices')
      end
    end

    it 'doesn`t throw any exception when receive route parameter' do
      expect(Validator.validate_vertices_presence(%w(a b), %w(a b))).to be_nil
    end
  end

  context '#validate_payload' do
    it 'throws a MissingParamsException when `from` param is missing' do
      begin
        Validator.validate_payload({ 'to' => 'b', 'value' => 10 })
        fail('Should have thrown an MissingParamsException')
      rescue MissingParamsException => e
        expect(e.message).to eq('Params: [from, to and value] are required')
      end
    end

    it 'throws a MissingParamsException when `to` param is missing' do
      begin
        Validator.validate_payload({ 'from' => 'a', 'value' => 10})
        fail('Should have thrown an MissingParamsException')
      rescue MissingParamsException => e
        expect(e.message).to eq('Params: [from, to and value] are required')
      end
    end

    it 'throws a MissingParamsException when `value` param is missing' do
      begin
        Validator.validate_payload({'from' => 'a', 'to' => 'b'})
        fail('Should have thrown an MissingParamsException')
      rescue MissingParamsException => e
        expect(e.message).to eq('Params: [from, to and value] are required')
      end
    end

    it 'doesn`t throw any exception when receive route parameter' do
      expect(Validator.validate_payload({'from' => 'a', 'to' => 'b', 'value' => 10})).to be_nil
    end
  end
end