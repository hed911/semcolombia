class Institucion::MuestrasController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def index
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    contacto = Contacto.where(son:@caso).first
    @parent = contacto.parent if contacto
    render layout:false
  end

  def new
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
  end

  def create
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]

    @muestra = Muestra.create! resultado:1, estado:1
    @muestra.fecha                   = params[:fecha]
    @muestra.tipo                    = params[:tipo]
    @muestra.otro_tipo               = params[:otro_tipo]
    @muestra.caso_salud_publica      = @caso
    @muestra.emisor                  = current_usuario
    @muestra.institucion             = @caso.institucion if @caso
    @muestra.save!
    @caso.generate_indexes
  end

  def show
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @muestra = Muestra.find params[:id]
    render layout:false
  end

  def update; end

  def destroy
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @muestra = Muestra.find params[:id]
    @muestra.destroy
    @caso.generate_indexes
  end

end
