require 'sinatra'
require 'json'

class UsersWebApp < Sinatra::Base

  USERS = { 1 => { "firstname" => "John", "lastname" => "Doe"},
          2 => { "firstname" => "Sue", "lastname" => "Helen"}
        }

  get '/users/:id' do
    user_id = params[:id].to_i
    return status 404 unless USERS[user_id]
    JSON.generate(USERS[user_id])
  end

  get '/users' do
    JSON.generate(USERS)
  end

  post '/users' do
    json_data = JSON.parse request.body.read
    return "firstname is missing" unless json_data['firstname']
    return "lastname is missing" unless json_data['lastname']
    USERS[USERS.keys.length + 1] = json_data
    status 200
  end

  delete '/users/:id' do
    user_id = params[:id].to_i
    return status 404 unless USERS[user_id]
    USERS.delete(user_id)
    status 200
  end

  run!
end