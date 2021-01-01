# encoding: UTF-8

class CitiesController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def neighborhoods
    @component_id = params[:component_id]
    @component_id = "neighboordhods" if @component_id == nil || @component_id == ""
    hash = {}
    city = City.find params[:id]
    @neighborhoods = city.neighborhoods.where(hash).order('created_at ASC')
  end

  private

end
