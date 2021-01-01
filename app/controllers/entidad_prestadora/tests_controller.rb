# encoding: UTF-8

class EntidadPrestadora::TestsController < ApplicationController
  before_action :authenticate_user!
  include PostgresqlDumper

  def index
    @laboratorios = Laboratorio.where(coordinacion: [nil, false], municipio: current_municipio).order("nombre ASC")
    @instituciones = Institucion.where(activo: true, municipio: current_municipio).order("nombre ASC")
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
  end

  def search
    hash = {}
    hash[:entidad_prestadora] = current_usuario.entidad_prestadora
    hash[:institucion] = Institucion.find_by_id(params[:institucion_id]) if !params[:institucion_id].nil? && !params[:institucion_id].empty?
    hash[:laboratorio] = Laboratorio.find_by_id(params[:laboratorio_id]) if !params[:laboratorio_id].nil? && !params[:laboratorio_id].empty?
    hash[:resultado] = params[:resultado] if !params[:resultado].nil? && !params[:resultado].empty?
    hash[:publico] = true if params[:resultado] == "2"
    hash[:estado] = params[:estado] if !params[:estado].nil? && !params[:estado].empty?
    hash[:fecha_recepcion_interna] = (Date.strptime(params[:start_date_recibido], "%Y-%m-%d").beginning_of_day..Date.strptime(params[:end_date_recibido], "%Y-%m-%d").end_of_day) if params[:start_date_recibido] != "" && params[:end_date_recibido] != ""
    hash[:fecha_despacho_interna] = (Date.strptime(params[:start_date_enviado], "%Y-%m-%d").beginning_of_day..Date.strptime(params[:end_date_enviado], "%Y-%m-%d").end_of_day) if params[:start_date_enviado] != "" && params[:end_date_enviado] != ""
    hash_caso = {}
    hash_caso["caso_salud_publicas.numero_oficial"] = params[:numero_oficial] if !params[:numero_oficial].nil? && !params[:numero_oficial].empty?
    hash_caso["caso_salud_publicas.id"] = params[:id] if !params[:id].nil? && !params[:id].empty?
    hash_caso["caso_salud_publicas.numero_documento"] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
    hash_caso["caso_salud_publicas.municipio_id"] = current_municipio.id
    hash_caso["caso_salud_publicas.sexo"] = params[:sexo] if !params[:sexo].nil? && !params[:sexo].empty?
    hash_caso["caso_salud_publicas.servicio"] = params[:servicio] if !params[:servicio].nil? && !params[:servicio].empty?

    @muestras = Muestra.where(hash).includes(:caso_salud_publica => [:entidad_prestadora], :institucion => [], :laboratorio => []).where(hash_caso)
    @muestras = @muestras.where("caso_salud_publicas.primer_nombre ILIKE '%#{params[:primer_nombre]}%'") if !params[:primer_nombre].nil? && !params[:primer_nombre].empty?
    @muestras = @muestras.where("caso_salud_publicas.primer_apellido ILIKE '%#{params[:primer_apellido]}%'") if !params[:primer_apellido].nil? && !params[:primer_apellido].empty?
    @muestras = @muestras.order("muestras.created_at DESC").paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @muestras.total_pages
    @cantidad_registros = @muestras.count
    @hide_buttons = true
    render template: "institucion/tests/search_pendientes", layout: false
  end

  def download
    where = ""
    where_lines = []
    where_lines << "(muestras.entidad_prestadora_id = #{current_usuario.entidad_prestadora.id})"
    where_lines << "(caso_salud_publicas.id = #{params[:id]})" if !params[:id].nil? && !params[:id].empty?
    where_lines << "(caso_salud_publicas.numero_documento = '#{params[:numero_documento_search]}')" if !params[:numero_documento_search].nil? && !params[:numero_documento_search].empty?
    where_lines << "(caso_salud_publicas.municipio_id = #{current_municipio.id})"
    where_lines << "(caso_salud_publicas.sexo = #{params[:sexo]})" if !params[:sexo].nil? && !params[:sexo].empty?
    where_lines << "(caso_salud_publicas.servicio = #{params[:servicio]})" if !params[:servicio].nil? && !params[:servicio].empty?
    where_lines << "(muestras.estado = #{params[:estado]})" if !params[:estado].nil? && !params[:estado].empty?
    where_lines << "(muestras.institucion_id = #{params[:institucion_id]})" if !params[:institucion_id].nil? && !params[:institucion_id].empty?
    where_lines << "(muestras.laboratorio_id = #{params[:laboratorio_id]})" if !params[:laboratorio_id].nil? && !params[:laboratorio_id].empty?
    where_lines << "(muestras.resultado = #{params[:resultado]})" if !params[:resultado].nil? && !params[:resultado].empty?
    where_lines << "(muestras.publico = TRUE)" if params[:resultado] == "2"
    where_lines << "(muestras.fecha_recepcion_interna between '#{Date.strptime(params[:start_date_recibido], "%Y-%m-%d")} 00:00:00' and '#{Date.strptime(params[:end_date_recibido], "%Y-%m-%d")} 23:59:00')" if !params[:start_date_recibido].nil? && !params[:start_date_recibido].empty? && !params[:end_date_recibido].nil? && !params[:end_date_recibido].empty?
    where_lines << "(muestras.fecha_despacho_interna between '#{Date.strptime(params[:start_date_enviado], "%Y-%m-%d")} 00:00:00' and '#{Date.strptime(params[:end_date_enviado], "%Y-%m-%d")} 23:59:00')" if !params[:start_date_enviado].nil? && !params[:start_date_enviado].empty? && !params[:end_date_enviado].nil? && !params[:end_date_enviado].empty?
    where = where_lines.join(" AND ")
    query = <<-FOO
      SELECT
      #{QUERY_TESTS}

      FROM muestras
      LEFT JOIN caso_salud_publicas
      ON muestras.caso_salud_publica_id = caso_salud_publicas.id
      LEFT JOIN institucions
      ON muestras.institucion_id = institucions.id
      LEFT JOIN entidad_prestadoras
      ON caso_salud_publicas.entidad_prestadora_id = entidad_prestadoras.id
      LEFT JOIN laboratorios
      ON muestras.laboratorio_id = laboratorios.id
      LEFT JOIN municipios
      ON caso_salud_publicas.municipio_id = municipios.id
      LEFT JOIN barrios
      ON caso_salud_publicas.barrio_id = barrios.id
      LEFT JOIN countries
      ON caso_salud_publicas.country_id = countries.id
      LEFT JOIN departamentos as departamento_residencia
      ON caso_salud_publicas.departamento_origen_id = departamento_residencia.id
      LEFT JOIN municipios as municipio_residencia
      ON caso_salud_publicas.municipio_origen_id = municipio_residencia.id
      LEFT JOIN usuarios as quien_recibe
      ON muestras.quien_recibe_id = quien_recibe.id
      LEFT JOIN usuarios as quien_despacha
      ON muestras.quien_despacha_id = quien_despacha.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    puts where_lines.join(" AND ")
    data = copy_to_string(query)
    send_data data, :filename => "dump_muestras.csv"
  end
end
