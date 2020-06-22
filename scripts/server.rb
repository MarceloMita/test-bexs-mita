require 'sinatra'
require 'byebug'

require_relative '../src/route.rb'
require_relative '../src/validator.rb'

set :show_exceptions, false

post '/routes' do
  payload = request.body.read
  prms = JSON.parse payload
  Validator.validate_payload(prms)
  if Route.create_edge(prms["from"], prms["to"], prms["value"])
    status 201
    body 'Edge created!'
  else
    raise UnprocessableEntityException(prms)
  end
end

get '/best-route' do
  Validator.validate_params_presence(params)
  Route.best_route(params)
end

error do |e|
  status e.status
  e.message
end
