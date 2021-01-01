class Crue::ReunionsController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def index
    @datetime_object = Time.now
    @datetime = @datetime_object.strftime('%Y-%m-%dT%T')
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial:false).order('nombre ASC')
    @instituciones = Institucion.where(activo:true, municipio:current_municipio).order('nombre ASC')
    @countries = Country.all.order('nombre ASC')
    @departamentos = Departamento.all.order('nombre ASC')
    @colombia = Country.find_by_codigo("co")
    @municipios = current_municipio.departamento.municipios.order('nombre ASC')
    @barrios = current_municipio.barrios.order('nombre ASC')
    @usuarios = Usuario.where(municipio:current_municipio, zoom_activated:true).order("primer_nombre ASC")
    render layout:false
  end

  def new
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
  end

  def create
    opentok = OpenTok::OpenTok.new '46763492', 'c3067de3aefc0d7697d4e097b101c61759f81dc8'
    session = nil
    @error = nil
    begin
      session = opentok.create_session
      @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
      @reunion = Reunion.create!
      #@reunion.uuid                       = SecureRandom.uuid
      @reunion.titulo                     = params[:titulo]
      @reunion.descripcion                = params[:descripcion]
      @reunion.fecha                      = Time.strptime(params[:fecha], '%Y-%m-%dT%T') if !params[:fecha].nil?
      @reunion.usuario                    = current_usuario
      @reunion.medico                     = Usuario.find_by_id params[:medico_id]
      @reunion.caso_salud_publica         = @caso
      @reunion.opentok_session_id         = session.session_id
      @reunion.opentok_host_token = session.generate_token({
        :role        => :moderator,
        :expire_time => Time.now.to_i + (7 * 24 * 60 * 60), # in one week
        :data        => "name=#{@reunion.medico.primer_nombre}",
        :initial_layout_class_list => ['focus', 'inactive']
      })
      @reunion.opentok_participant_token = session.generate_token({
        :role        => :publisher,
        :expire_time => Time.now.to_i + (7 * 24 * 60 * 60), # in one week
        :data        => "name=#{@caso.primer_nombre}",
        :initial_layout_class_list => ['focus', 'inactive']
      })
      @reunion.save!
    rescue => e
      @error = "Error no se pudo crear la sesion en opentok, vuelva a intentar o contacte a un administrador."
    end
  end

  def destroy
    @parent = CasoSaludPublica.find_by_id params[:caso_salud_publica_id]
    @reunion = Reunion.find_by_id params[:id]
    @reunion.destroy!
  end

  def pendientes

  end

  def search_pendientes
    @reunions = current_usuario.reunions.where(fecha:Time.now.beginning_of_day..Time.now.end_of_day)
    @reunions = @reunions.order('reunions.created_at DESC').paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @reunions.total_pages
    @cantidad_registros = @reunions.count
    render template:'crue/reunions/search_pendientes', layout: false
  end

  def show
    @reunion = Reunion.find_by_opentok_host_token(params[:id])
    @reunion = Reunion.find_by_opentok_participant_token(params[:id]) if @reunion.nil?
    @is_host = @reunion && @reunion.opentok_host_token == params[:id]
  end

end
