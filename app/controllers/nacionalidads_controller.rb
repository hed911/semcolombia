class NacionalidadsController < ApplicationController
  require 'net/http'
  before_action :authenticate_usuario!

  def search
    term = params[:term] ? params[:term].downcase : ""
    @nacionalidades = Nacionalidad.where 'nombre ILIKE ? OR codigo ILIKE ?', "%#{term}%", "%#{term}%"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: array_json(@nacionalidades) }
    end
  end

  def array_json(nacionalidades)
    result = Jbuilder.encode do |json|
      json.array! nacionalidades do |nacionalidad|
        json.call(
          nacionalidad,
          :id,
          :codigo
        )
        json.set! :nombre, (nacionalidad.nombre ? nacionalidad.nombre.upcase : nil)
      end
    end
    result
  end
end
