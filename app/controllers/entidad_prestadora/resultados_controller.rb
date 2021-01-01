# encoding: UTF-8

class EntidadPrestadora::ResultadosController < ApplicationController
  before_action :authenticate_user!

  def index

  end

  def search
    #if params[:numero_documento] && params[:numero_documento] != ""
      hash_caso = {}
      hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if params[:numero_documento] && params[:numero_documento] != ""
      hash_caso['caso_salud_publicas.entidad_prestadora_id'] = current_usuario.entidad_prestadora.id
      hash_caso['caso_salud_publicas.municipio_id'] = current_municipio.id
      @muestras = Muestra.where.not({}).includes([:caso_salud_publica]).where(hash_caso)
      @muestras = @muestras.order("muestras.created_at DESC").paginate(page: params[:index].to_i, per_page: params[:size].to_i)
      @cantidad_paginas = @muestras.total_pages
      @cantidad_registros = @muestras.count
    #else
    #  @muestras = []
    #  @cantidad_paginas = 0
    #  @cantidad_registros = 0
    #end
    render layout: false
  end

  def pendientes

  end

  def search_pendientes
    hash_caso = {}
    hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if params[:numero_documento] && params[:numero_documento] != ""
    hash_caso['caso_salud_publicas.entidad_prestadora_id'] = current_usuario.entidad_prestadora.id
    hash_caso['caso_salud_publicas.municipio_id'] = current_municipio.id
    @muestras = Muestra.where.not(estado:[4, 5]).includes([:caso_salud_publica]).where(hash_caso)
    @muestras = @muestras.order('muestras.created_at DESC').paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @muestras.total_pages
    @cantidad_registros = @muestras.count
    render layout: false
  end

  def hoy

  end

  def search_hoy
    hash_caso = {}
    hash_caso['caso_salud_publicas.municipio_id'] = current_municipio.id
    hash_caso['caso_salud_publicas.entidad_prestadora_id'] = current_usuario.entidad_prestadora.id
    hash = {}
    if params[:tipo] == "positivo"
      hash[:resultado] = 2
      hash[:publico] = true
    end
    hash[:resultado] = 3 if params[:tipo] == "negativo"
    hash[:resultado] = 4 if params[:tipo] == "no_se_pudo"
    if params[:start_date] && params[:start_date] != "" && params[:end_date] && params[:end_date] != ""
      hash[:fecha_procesado_interna] = DateTime.parse(params[:start_date]).beginning_of_day..DateTime.parse(params[:end_date]).end_of_day
    end
    @muestras = Muestra.where(hash).includes([:caso_salud_publica]).where(hash_caso)
    @muestras = @muestras.order('muestras.created_at DESC').paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @muestras.total_pages
    @cantidad_registros = @muestras.count
    render template:"entidad_prestadora/resultados/search", layout: false
  end

end
