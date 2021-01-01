# encoding: UTF-8

class DepartamentsController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def cities
    @component_id = params[:component_id]
    @component_id = "cities" if @component_id == nil || @component_id == ""
    hash = {}
    department = Department.find params[:id]
    @cities = department.cities.where(hash).order('created_at ASC')
  end

end
