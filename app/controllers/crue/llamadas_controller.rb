# encoding: UTF-8

class Crue::LlamadasController < ApplicationController
  before_action :authenticate_usuario!

  def entrantes

  end

  def index
    @intensions = Intension.where(municipio:current_municipio).order('nombre ASC')
  end

  def search
    hash = {}
    hash[:created_at] = (Date.strptime(params[:start_date], '%Y-%m-%d').beginning_of_day..Date.strptime(params[:end_date], '%Y-%m-%d').end_of_day) if params[:start_date] != '' && params[:end_date] != ''
    hash[:id] = params[:id] if params[:id] && params[:id] != ''
    hash[:numero_documento] = params[:numero_documento].strip if params[:numero_documento] && params[:numero_documento] != ''
    hash[:intension] = Intension.find_by_id(params[:intension_id]) if params[:intension_id] && params[:intension_id] != ''
    hash[:municipio] = current_municipio
    hash[:usuario] = current_usuario
    @llamadas = Llamada.where(hash).includes([:usuario]).where(hash)
    @llamadas = @llamadas.order("llamadas.created_at DESC").paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @llamadas.total_pages
    render layout: false
  end

  def search_entrantes
    @llamadas = Llamada.where(usuario:current_usuario).order('created_at DESC').paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @llamadas.total_pages
    render template: 'crue/llamadas/search', layout: false
  end

  def pendientes

  end

  def search_pendientes
    hash = {municipio:current_municipio, estado:ESTADO_SP_VIGENTE}
    if params[:tipo] == '1'
      hash[:usuario_seguimiento] = [nil]
    elsif params[:tipo] == '2'
      hash[:usuario_seguimiento] = [current_usuario]
    else
      hash[:usuario_seguimiento] = [nil, current_usuario]
    end
    #@casos = CasoSaludPublica.where("NOT EXISTS (SELECT 1 FROM seguimiento_casos WHERE seguimiento_casos.caso_salud_publica_id = caso_salud_publicas.id AND DATE(seguimiento_casos.created_at) = now()::date) AND EXISTS (SELECT 1 FROM contactos as c INNER JOIN caso_salud_publicas as csp on c.parent_id = csp.id WHERE c.son_id = caso_salud_publicas.id AND csp.estado_enfermedad = 2 AND csp.publico = TRUE)")
    @casos = CasoSaludPublica.where("NOT EXISTS (SELECT 1 FROM seguimiento_casos WHERE seguimiento_casos.caso_salud_publica_id = caso_salud_publicas.id AND DATE(seguimiento_casos.created_at) = now()::date) AND caso_salud_publicas.responsable_investigacion_id IS NOT NULL")
    @casos = @casos.where(hash)
    @casos = @casos.where.not({responsable_investigacion:nil})
    @casos = @casos.order('created_at DESC').paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @casos.total_pages
    render layout: false
  end

  def show
    @caso = CasoSaludPublica.find_by_id params[:id]
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial:false).order('nombre ASC')
    @aseguradoras = Aseguradora.all.order('nombre ASC')
    @countries = Country.all.order('nombre ASC')
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial:false).order('nombre ASC')
    @departamentos = Departamento.all.order('nombre ASC')
    @colombia = Country.find_by_codigo("co")
    @municipios = @caso.departamento_origen.nil? ? [] : @caso.departamento_origen.municipios.order('nombre ASC')
    @barrios = @caso.municipio_origen.nil? ? [] : @caso.municipio_origen.barrios.order('nombre ASC')
    @municipios_contacto_uno = @caso.departamento_contacto_uno.nil? ? [] : @caso.departamento_contacto_uno.municipios.order('nombre ASC')
    render layout:false
  end

  def new
    @intensions = Intension.where(municipio:current_municipio).order("nombre ASC")
    @departamentos = Departamento.all.order('nombre ASC')
    @municipios = current_municipio.departamento.municipios.order('nombre ASC')
    render layout:false
  end

  def create
    @llamada = Llamada.create!
    @llamada.tipo_documento             = params[:tipo_documento]
    @llamada.numero_documento           = params[:numero_documento]
    @llamada.primer_nombre              = params[:primer_nombre]
    @llamada.primer_apellido            = params[:primer_apellido]
    @llamada.segundo_nombre             = params[:segundo_nombre]
    @llamada.segundo_apellido           = params[:segundo_apellido]
    @llamada.email                      = params[:email]
    @llamada.telefono_fijo              = params[:telefono_fijo]
    @llamada.celular                    = params[:celular]

    @llamada.departamento               = current_municipio.departamento
    @llamada.municipio                  = current_municipio

    @llamada.intension                  = Intension.find_by_id(params[:intension_id])
    @llamada.descripcion                = params[:descripcion]
    @llamada.autoriza                   = params[:autoriza] == "1"
    @llamada.usuario = current_usuario
    @llamada.save!
  end

  def edit
    @llamada = Llamada.find_by_id params[:id]
    @intensions = Intension.where(municipio:current_municipio).order("nombre ASC")
    @departamentos = Departamento.all.order('nombre ASC')
    @municipios = @llamada.departamento.nil? ? [] : @llamada.departamento.municipios.order('nombre ASC')
    render layout:false
  end

  def update
    @llamada = Llamada.find_by_id params[:id]
    @llamada.tipo_documento             = params[:tipo_documento]
    @llamada.numero_documento           = params[:numero_documento]
    @llamada.primer_nombre              = params[:primer_nombre]
    @llamada.primer_apellido            = params[:primer_apellido]
    @llamada.segundo_nombre             = params[:segundo_nombre]
    @llamada.segundo_apellido           = params[:segundo_apellido]
    @llamada.email                      = params[:email]
    @llamada.telefono_fijo              = params[:telefono_fijo]
    @llamada.celular                    = params[:celular]

    @llamada.departamento               = current_municipio.departamento
    @llamada.municipio                  = current_municipio

    @llamada.intension                  = Intension.find_by_id(params[:intension_id])
    @llamada.descripcion                = params[:descripcion]
    @llamada.autoriza                   = params[:autoriza] == "1"
    @llamada.save!
  end

  def destroy
    @llamada = Llamada.find_by_id params[:id]
    caso_salud_publica = @llamada.caso_salud_publica
    caso_salud_publica.destroy if caso_salud_publica
    @llamada.destroy!
  end

  def show
    @llamada = Llamada.find_by_id params[:id]
    @intensions = Intension.where(municipio:current_municipio).order("nombre ASC").to_a
    @departamentos = Departamento.all.order('nombre ASC')
    @municipios = @llamada.departamento_origen.nil? ? [] : @llamada.departamento_origen.municipios.order('nombre ASC')
    render layout:false
  end

end
