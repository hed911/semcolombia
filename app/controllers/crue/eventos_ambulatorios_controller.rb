class Crue::EventosAmbulatoriosController < ApplicationController
  require 'net/http'
  before_action :authenticate_usuario!
  respond_to :html, :js

  def reverse_geocode
    response = HTTParty.post("https://sitidata-stdr.appspot.com/api/geoinverso",
    {
      body: {
      	latitude:params[:latitude],
      	longitude:params[:longitude]
      },
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token 2UAJLPCFRXHXPBQNC74NKMVPH6HMVJ'
      }
    })
    render json: response["data"]
  end

  def geocode
    response = HTTParty.post("https://sitidata-stdr.appspot.com/api/geocoder",
    {
      body: {
      	address:params[:direccion],
      	city: current_municipio.nombre
      },
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token 2UAJLPCFRXHXPBQNC74NKMVPH6HMVJ'
      }
    })
    puts "EL RESULT ES: #{response.to_json}"
    render json: {uuid:params[:uuid], latitude:response["data"]["latitude"], longitude:response["data"]["longitude"]}.to_json
  end

end
