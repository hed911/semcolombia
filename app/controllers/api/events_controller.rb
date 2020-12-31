class Api::EventsController < ApplicationController #REVISADO
  require 'net/http'
  before_action :authorize_request
  include ApiHelper

  def index
    if @current_user.city.id == BARRANQUILLA_ID
      result = ApiHelper.fetch_events_barranquilla(params)
    elsif @current_user.city.id == CARTAGENA_ID
      result = ApiHelper.fetch_events_cartagena(params)
    else
      result = ApiHelper.fetch_events(params)
    end
    if result[:errors].any?
      render json: {
        :status => "error",
        :data => {},
        :message => result[:errors].join(", ")
      }.to_json, status: 400
      return
    else
      render json:result[:data]
    end
  end

end

class String
  def numeric?
    return true if self =~ /\A\d+\Z/
    true if Float(self) rescue false
  end
end
