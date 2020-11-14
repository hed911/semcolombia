class Crue::XeunionsController < ApplicationController
  require "net/http"
  before_action :authenticate_usuario!

  def index
    @datetime_object = Time.now
    @datetime = @datetime_object.strftime("%Y-%m-%dT%T")
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
    @instituciones = Institucion.where(activo: true, municipio: current_municipio).order("nombre ASC")
    @countries = Country.all.order("nombre ASC")
    @departamentos = Departamento.all.order("nombre ASC")
    @colombia = Country.find_by_codigo("co")
    @municipios = current_municipio.departamento.municipios.order("nombre ASC")
    @barrios = current_municipio.barrios.order("nombre ASC")
    @usuarios = Usuario.where(municipio: current_municipio, zoom_activated: true).order("primer_nombre ASC")
    render layout: false
  end

  def new
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
  end

  def create
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @reunion = Reunion.create!
    @reunion.titulo = params[:titulo]
    @reunion.descripcion = params[:descripcion]
    @reunion.fecha = Time.strptime(params[:fecha], "%Y-%m-%dT%T") if !params[:fecha].nil?
    @reunion.usuario = current_usuario
    @reunion.medico = Usuario.find_by_id params[:medico_id]
    @reunion.caso_salud_publica = @caso
    @reunion.save!

    result = nil
    hubo_error = false
    begin
      result = ZoomHelper.create_meeting(
        @reunion.titulo,
        @reunion.fecha,
        "#{rand 000000..999999}",
        @reunion.descripcion,
        @reunion.medico.zoom_id
      )
      hubo_error = result[:code] != 201
    rescue => e
      puts "ERROR CON LA API :S #{e.message}"
      hubo_error = true
    end
    if hubo_error
      @reunion.destroy!
    else
      @reunion.zoom_uuid = result[:response]["uuid"]
      @reunion.zoom_id = result[:response]["id"]
      @reunion.zoom_uuid = result[:response]["uuid"]
      @reunion.zoom_host_id = result[:response]["host_id"]
      @reunion.zoom_start_url = result[:response]["start_url"]
      @reunion.zoom_join_url = result[:response]["join_url"]
      @reunion.zoom_password = result[:response]["password"]
      @reunion.save!
    end
  end

  def destroy
    @parent = CasoSaludPublica.find_by_id params[:caso_salud_publica_id]
    @reunion = Reunion.find_by_id params[:id]
    @reunion.destroy!
  end
end
