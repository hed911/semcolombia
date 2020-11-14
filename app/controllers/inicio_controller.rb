class InicioController < ApplicationController
  require 'net/http'
  before_action :authenticate_usuario!, except:[:crack]

  def crack
    render layout:false
    request.format = 'json'
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def index
    if current_usuario.es_super_admin
      redirect_to crue_super_admins_path
    else
      if current_institucion.nil? && current_usuario.entidad_prestadora.nil? && current_usuario.laboratorio.nil?
        #redirect_to dashboard_crue_caso_salud_publicas_path
      end
    end
  end

end
