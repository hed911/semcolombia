class Crue::DesplazamientosController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def index
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    contacto = Contacto.where(son:@caso).first
  end

  def new
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
  end

  def create
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @desplazamiento = Desplazamiento.create!(contenido: params[:contenido], fecha: params[:fecha])
    @desplazamiento.caso_salud_publica = @caso
    @desplazamiento.usuario = current_usuario
    @desplazamiento.save!
  end

  def show; end

  def edit
    @caso = CasoSaludPublica.find(params[:caso_salud_publica_id])
    @desplazamiento = Desplazamiento.find(params[:id])
  end

  def update; end

  def destroy
    @caso = CasoSaludPublica.find(params[:caso_salud_publica_id])
    @desplazamiento = Desplazamiento.find(params[:id])
    @desplazamiento.destroy!
  end

end
