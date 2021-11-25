# frozen_string_literal: true

require_relative '../env/default'
require 'sinatra'

get '/:queue_name' do
  second = params['seconds'] || params['second']

  id = Manager.get params['queue_name'], second
  JSON.generate({ status: :Ok, id: id })
end

delete '/:queue_name/:id' do
  time = Manager.remove params['queue_name'], params['id']
  JSON.generate({ status: :Ok, locked: "#{time} seconds" })
end

get '/' do
  :Ok
end

get '/health' do
  :Ok
end

App.start_loop
