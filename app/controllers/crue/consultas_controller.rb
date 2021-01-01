class Crue::ConsultasController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def destroy
    @caso = CasoSaludPublica.find(params[:caso_salud_publica_id])
    @consulta = Consulta.find(params[:id])
    @consulta.destroy!
  end

end
