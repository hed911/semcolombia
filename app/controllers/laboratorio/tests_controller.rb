# encoding: UTF-8

class Laboratorio::TestsController < ApplicationController
  before_action :authenticate_usuario!
  include PostgresqlDumper

  def index
    @laboratorios = Laboratorio.where(coordinacion: [nil, false], municipio: current_municipio).order("nombre ASC")
    @instituciones = Institucion.where(activo: true, municipio: current_municipio).order("nombre ASC")
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
  end

  def search
    where = ""
    where_lines = []
    where_lines << "(muestra.institucion_id = #{params[:institucion_id]})" if !params[:institucion_id].nil? && !params[:institucion_id].empty?
    where_lines << "(muestra.laboratorio_id = #{current_usuario.laboratorio.id})" if !current_usuario.laboratorio.coordinacion
    where_lines << "(muestra.resultado = #{params[:resultado]})" if !params[:resultado].nil? && !params[:resultado].empty?
    where_lines << "(caso.publico = TRUE)" if params[:resultado] == "2"
    where_lines << "(muestra.estado = #{params[:estado]})" if !params[:estado].nil? && !params[:estado].empty?
    where_lines << "(muestra.fecha_recepcion_interna between ('#{Date.strptime(params[:start_date_recibido], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date_recibido], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date_recibido].nil? && !params[:start_date_recibido].empty? && !params[:end_date_recibido].nil? && !params[:end_date_recibido].empty?
    where_lines << "(muestra.fecha_despacho_interna between ('#{Date.strptime(params[:start_date_enviado], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date_enviado], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date_enviado].nil? && !params[:start_date_enviado].empty? && !params[:end_date_enviado].nil? && !params[:end_date_enviado].empty?
    where_lines << "(caso.numero_oficial = #{params[:numero_oficial]})" if !params[:numero_oficial].nil? && !params[:numero_oficial].empty?
    where_lines << "(caso.id = #{params[:id]})" if !params[:id].nil? && !params[:id].empty?
    where_lines << "(caso.numero_documento = '#{params[:numero_documento]}')" if !params[:numero_documento].nil? && !params[:numero_documento].empty?
    where_lines << "(caso.municipio_id = #{current_municipio.id})"
    where_lines << "(caso.entidad_prestadora_id = #{params[:entidad_prestadora_id]})" if !params[:entidad_prestadora_id].nil? && !params[:entidad_prestadora_id].empty?
    where_lines << "(caso.sexo = #{params[:sexo]})" if !params[:sexo].nil? && !params[:sexo].empty?
    where_lines << "(caso.servicio = #{params[:servicio]})" if !params[:servicio].nil? && !params[:servicio].empty?
    where_lines << "(caso.primer_nombre ILIKE '%#{params[:primer_nombre]}%')" if !params[:primer_nombre].nil? && !params[:primer_nombre].empty?
    where_lines << "(caso.primer_apellido ILIKE '%#{params[:primer_apellido]}%')" if !params[:primer_apellido].nil? && !params[:primer_apellido].empty?

    where = where_lines.join(" AND ")
    select = <<-FOO
      muestra.id AS muestra_id,
      caso.numero_oficial AS caso_numero_oficial,
      muestra.fecha_recepcion_interna_laboratorio_asignado AS muestra_fecha_recepcion_interna_laboratorio_asignado,
      caso.id AS caso_id,
      CASE
        WHEN muestra.tipo = 1 THEN 'ASPIRADO TRAQUEAL'
        WHEN muestra.tipo = 2 THEN 'LAVADO BRONCOALVEORAL'
        WHEN muestra.tipo = 3 THEN 'HISOPADO NASOFARINGEO'
        WHEN muestra.tipo = 4 THEN 'ASPIRADO NASOFARIGEO'
        WHEN muestra.tipo = 5 THEN muestra.otro_tipo
        ELSE ''
      END AS muestra_tipo_value,
      CASE
        WHEN muestra.resultado = 1 THEN ''
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'table-danger'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'table-success'
        WHEN muestra.resultado = 4 THEN 'table-warning'
        ELSE ''
      END AS muestra_table_value,
      CASE
        WHEN muestra.estado = 1 THEN 'MUESTRA TOMADA'
        WHEN muestra.estado = 2 THEN 'MUESTRA RECIBIDA POR COORDINADOR'
        WHEN muestra.estado = 3 THEN 'MUESTRA ASIGNADA A LABORATORIO'
        WHEN muestra.estado = 4 THEN 'MUESTRA RECHAZADA'
        WHEN muestra.estado = 5 THEN 'MUESTRA PROCESADA'
        ELSE ''
      END AS muestra_estado_value,
      muestra.estado AS muestra_estado,
      concat(caso.primer_nombre, ' ', caso.segundo_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_apellido) AS caso_nombre_completo,
      CASE
        WHEN caso.edad IS NOT NULL THEN caso.edad
        WHEN caso.fecha_nacimiento IS NOT NULL THEN (date_part('year', AGE(caso.fecha_nacimiento)) )
        ELSE NULL
      END AS caso_edad_value,
      CASE
        WHEN caso.unidad_medida = 1 THEN 'AÑOS'
        WHEN caso.unidad_medida = 2 THEN 'MESES'
        WHEN caso.unidad_medida = 3 THEN 'DIAS'
        ELSE ''
      END AS caso_unidad_medida_value,
      caso.tipo_documento AS caso_tipo_documento,
      caso.numero_documento AS caso_numero_documento,
      entidad_prestadora.nombre AS entidad_prestadora_nombre,
      institucion.nombre AS institucion_nombre,
      CASE
        WHEN caso.servicio = 1 THEN 'HOSPITALIZACION'
        WHEN caso.servicio = 2 THEN 'URGENCIA'
        WHEN caso.servicio = 3 THEN 'UCI PLENA'
        WHEN caso.servicio = 4 THEN 'UCI INTERNEDIA'
        WHEN caso.servicio = 0 THEN 'NO TIENE'
        WHEN caso.servicio = 5 THEN 'AMBULATORIO'
        ELSE ''
      END AS caso_servicio_value,
      laboratorio.nombre AS laboratorio_nombre,
      DATE(muestra.fecha) AS muestra_fecha,
      DATE(muestra.fecha_recepcion_interna) AS muestra_fecha_recepcion_interna,
      DATE(muestra.fecha_despacho_interna) AS muestra_fecha_despacho_interna,
      muestra.resultado AS muestra_resultado,
      muestra.publico AS muestra_publico,
      CASE
        WHEN muestra.resultado = 1 THEN 'POR DEFINIR'
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'POSITIVO'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'NEGATIVO'
        WHEN muestra.resultado = 4 THEN 'SE SOLICITA NUEVA MUESTRA'
        ELSE ''
      END AS muestra_resultado_value,
      muestra.created_at AS muestra_created_at
    FOO

    query = <<-FOO
      SELECT
      #{select}
      FROM muestras AS muestra
      LEFT JOIN caso_salud_publicas AS caso
      ON muestra.caso_salud_publica_id = caso.id
      LEFT JOIN laboratorios AS laboratorio
      ON muestra.laboratorio_id = laboratorio.id
      LEFT JOIN institucions AS institucion
      ON muestra.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
      ORDER BY muestra.created_at DESC
    FOO

    query_paged = <<-FOO
      #{query}
      LIMIT #{params[:size]}
      OFFSET #{params[:index].to_i - 1}
    FOO
    query_counter = <<-FOO
      SELECT COUNT(*)
      FROM muestras AS muestra
      LEFT JOIN caso_salud_publicas AS caso
      ON muestra.caso_salud_publica_id = caso.id
      LEFT JOIN laboratorios AS laboratorio
      ON muestra.laboratorio_id = laboratorio.id
      LEFT JOIN institucions AS institucion
      ON muestra.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    @registros = ActiveRecord::Base.connection.execute(query_paged)
    @cantidad = ActiveRecord::Base.connection.execute(query_counter)
    @cantidad_registros = @cantidad[0]["count"]
    @cantidad_paginas = (@cantidad_registros / params[:size].to_i).ceil
    render template: "laboratorio/tests/search_pendientes", layout: false
  end

  def pendientes
  end

  def search_pendientes
    where = ""
    where_lines = []
    where_lines << "(muestra.estado = 1 OR muestra.estado = 2)"
    where_lines << "(caso.numero_documento = '#{params[:numero_documento]}')" if !params[:numero_documento].nil? && !params[:numero_documento].empty?
    where_lines << "(caso.municipio_id = #{current_municipio.id})"

    where = where_lines.join(" AND ")
    select = <<-FOO
      muestra.id AS muestra_id,
      caso.numero_oficial AS caso_numero_oficial,
      muestra.fecha_recepcion_interna_laboratorio_asignado AS muestra_fecha_recepcion_interna_laboratorio_asignado,
      caso.id AS caso_id,
      CASE
        WHEN muestra.tipo = 1 THEN 'ASPIRADO TRAQUEAL'
        WHEN muestra.tipo = 2 THEN 'LAVADO BRONCOALVEORAL'
        WHEN muestra.tipo = 3 THEN 'HISOPADO NASOFARINGEO'
        WHEN muestra.tipo = 4 THEN 'ASPIRADO NASOFARIGEO'
        WHEN muestra.tipo = 5 THEN muestra.otro_tipo
        ELSE ''
      END AS muestra_tipo_value,
      CASE
        WHEN muestra.resultado = 1 THEN ''
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'table-danger'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'table-success'
        WHEN muestra.resultado = 4 THEN 'table-warning'
        ELSE ''
      END AS muestra_table_value,
      CASE
        WHEN muestra.estado = 1 THEN 'MUESTRA TOMADA'
        WHEN muestra.estado = 2 THEN 'MUESTRA RECIBIDA POR COORDINADOR'
        WHEN muestra.estado = 3 THEN 'MUESTRA ASIGNADA A LABORATORIO'
        WHEN muestra.estado = 4 THEN 'MUESTRA RECHAZADA'
        WHEN muestra.estado = 5 THEN 'MUESTRA PROCESADA'
        ELSE ''
      END AS muestra_estado_value,
      muestra.estado AS muestra_estado,
      concat(caso.primer_nombre, ' ', caso.segundo_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_apellido) AS caso_nombre_completo,
      CASE
        WHEN caso.edad IS NOT NULL THEN caso.edad
        WHEN caso.fecha_nacimiento IS NOT NULL THEN (date_part('year', AGE(caso.fecha_nacimiento)) )
        ELSE NULL
      END AS caso_edad_value,
      CASE
        WHEN caso.unidad_medida = 1 THEN 'AÑOS'
        WHEN caso.unidad_medida = 2 THEN 'MESES'
        WHEN caso.unidad_medida = 3 THEN 'DIAS'
        ELSE ''
      END AS caso_unidad_medida_value,
      caso.tipo_documento AS caso_tipo_documento,
      caso.numero_documento AS caso_numero_documento,
      entidad_prestadora.nombre AS entidad_prestadora_nombre,
      institucion.nombre AS institucion_nombre,
      CASE
        WHEN caso.servicio = 1 THEN 'HOSPITALIZACION'
        WHEN caso.servicio = 2 THEN 'URGENCIA'
        WHEN caso.servicio = 3 THEN 'UCI PLENA'
        WHEN caso.servicio = 4 THEN 'UCI INTERNEDIA'
        WHEN caso.servicio = 0 THEN 'NO TIENE'
        WHEN caso.servicio = 5 THEN 'AMBULATORIO'
        ELSE ''
      END AS caso_servicio_value,
      laboratorio.nombre AS laboratorio_nombre,
      DATE(muestra.fecha) AS muestra_fecha,
      DATE(muestra.fecha_recepcion_interna) AS muestra_fecha_recepcion_interna,
      DATE(muestra.fecha_despacho_interna) AS muestra_fecha_despacho_interna,
      muestra.resultado AS muestra_resultado,
      muestra.publico AS muestra_publico,
      CASE
        WHEN muestra.resultado = 1 THEN 'POR DEFINIR'
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'POSITIVO'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'NEGATIVO'
        WHEN muestra.resultado = 4 THEN 'SE SOLICITA NUEVA MUESTRA'
        ELSE ''
      END AS muestra_resultado_value,
      muestra.created_at AS muestra_created_at
    FOO

    query = <<-FOO
      SELECT
      #{select}
      FROM muestras AS muestra
      LEFT JOIN caso_salud_publicas AS caso
      ON muestra.caso_salud_publica_id = caso.id
      LEFT JOIN laboratorios AS laboratorio
      ON muestra.laboratorio_id = laboratorio.id
      LEFT JOIN institucions AS institucion
      ON muestra.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
      ORDER BY muestra.created_at DESC
    FOO

    query_paged = <<-FOO
      #{query}
      LIMIT #{params[:size]}
      OFFSET #{params[:index].to_i - 1}
    FOO
    query_counter = <<-FOO
      SELECT COUNT(*)
      FROM muestras AS muestra
      LEFT JOIN caso_salud_publicas AS caso
      ON muestra.caso_salud_publica_id = caso.id
      LEFT JOIN laboratorios AS laboratorio
      ON muestra.laboratorio_id = laboratorio.id
      LEFT JOIN institucions AS institucion
      ON muestra.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    @registros = ActiveRecord::Base.connection.execute(query_paged)
    @cantidad = ActiveRecord::Base.connection.execute(query_counter)
    @cantidad_registros = @cantidad[0]["count"]
    @cantidad_paginas = (@cantidad_registros / params[:size].to_i).ceil
    render template: "laboratorio/tests/search_pendientes", layout: false
  end

  def recibir
    @datetime_object = Time.now
    @datetime = @datetime_object.strftime("%Y-%m-%dT%T")

    @muestra = Muestra.find_by_id params[:id]
    @laboratorios = Laboratorio.where(coordinacion: [nil, false], municipio: current_municipio).order("nombre ASC")
    render layout: false
  end

  def do_recibir
    @muestra = Muestra.find_by_id params[:id]
    fecha = Time.strptime(params[:fecha_recepcion], "%Y-%m-%dT%T") if !params[:fecha_recepcion].nil?
    @muestra.estado = params[:estado] == "1" ? 2 : 4
    @muestra.fecha_recepcion_interna = fecha
    @muestra.observaciones = params[:observaciones].tr("<", "").tr(">", "").tr('"', "").tr("\r", "").tr("\n", "").tr(";", ",") if params[:observaciones]
    @muestra.quien_recibe = current_usuario
    @muestra.save!
  end

  def do_recibir_asignado
    @muestra = Muestra.find_by_id params[:id]
    @muestra.fecha_recepcion_interna_laboratorio_asignado = Time.now
    @muestra.save!
  end

  def despachar
    @datetime_object = Time.now
    @datetime = @datetime_object.strftime("%Y-%m-%dT%T")

    @muestra = Muestra.find_by_id params[:id]
    @laboratorios = Laboratorio.where(coordinacion: [nil, false], municipio: current_municipio).order("nombre ASC")
    render layout: false
  end

  def do_despachar
    laboratorio = Laboratorio.find_by_id params[:laboratorio_id]
    laboratorio_confirmacion = Laboratorio.find_by_id params[:laboratorio_confirmacion_id]
    if laboratorio_confirmacion.id != laboratorio.id
      @error = "El laboratorio de confirmacion no corresponde con el laboratorio seleccionado"
      return
    end
    @muestra = Muestra.find_by_id params[:id]
    @muestra.laboratorio = Laboratorio.find_by_id params[:laboratorio_id]
    @muestra.fecha_despacho_interna = Time.strptime(params[:fecha_despacho], "%Y-%m-%dT%T") if !params[:fecha_despacho].nil?
    @muestra.estado = 3
    @muestra.observaciones = params[:observaciones].tr("<", "").tr(">", "").tr('"', "").tr("\r", "").tr("\n", "").tr(";", ",") if params[:observaciones]
    @muestra.quien_despacha = current_usuario
    @muestra.save!
  end

  def recibidas
  end

  def search_recibidas
    where = ""
    where_lines = []
    where_lines << "(muestra.fecha_recepcion_interna between ('#{Time.now.in_time_zone("America/Los_Angeles").strftime("%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Time.now.in_time_zone("America/Los_Angeles").strftime("%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')"
    where_lines << "(caso.numero_documento = '#{params[:numero_documento]}')" if !params[:numero_documento].nil? && !params[:numero_documento].empty?
    where_lines << "(caso.municipio_id = #{current_municipio.id})"

    where = where_lines.join(" AND ")
    select = <<-FOO
      muestra.id AS muestra_id,
      caso.numero_oficial AS caso_numero_oficial,
      muestra.fecha_recepcion_interna_laboratorio_asignado AS muestra_fecha_recepcion_interna_laboratorio_asignado,
      caso.id AS caso_id,
      CASE
        WHEN muestra.tipo = 1 THEN 'ASPIRADO TRAQUEAL'
        WHEN muestra.tipo = 2 THEN 'LAVADO BRONCOALVEORAL'
        WHEN muestra.tipo = 3 THEN 'HISOPADO NASOFARINGEO'
        WHEN muestra.tipo = 4 THEN 'ASPIRADO NASOFARIGEO'
        WHEN muestra.tipo = 5 THEN muestra.otro_tipo
        ELSE ''
      END AS muestra_tipo_value,
      CASE
        WHEN muestra.resultado = 1 THEN ''
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'table-danger'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'table-success'
        WHEN muestra.resultado = 4 THEN 'table-warning'
        ELSE ''
      END AS muestra_table_value,
      CASE
        WHEN muestra.estado = 1 THEN 'MUESTRA TOMADA'
        WHEN muestra.estado = 2 THEN 'MUESTRA RECIBIDA POR COORDINADOR'
        WHEN muestra.estado = 3 THEN 'MUESTRA ASIGNADA A LABORATORIO'
        WHEN muestra.estado = 4 THEN 'MUESTRA RECHAZADA'
        WHEN muestra.estado = 5 THEN 'MUESTRA PROCESADA'
        ELSE ''
      END AS muestra_estado_value,
      muestra.estado AS muestra_estado,
      concat(caso.primer_nombre, ' ', caso.segundo_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_apellido) AS caso_nombre_completo,
      CASE
        WHEN caso.edad IS NOT NULL THEN caso.edad
        WHEN caso.fecha_nacimiento IS NOT NULL THEN (date_part('year', AGE(caso.fecha_nacimiento)) )
        ELSE NULL
      END AS caso_edad_value,
      CASE
        WHEN caso.unidad_medida = 1 THEN 'AÑOS'
        WHEN caso.unidad_medida = 2 THEN 'MESES'
        WHEN caso.unidad_medida = 3 THEN 'DIAS'
        ELSE ''
      END AS caso_unidad_medida_value,
      caso.tipo_documento AS caso_tipo_documento,
      caso.numero_documento AS caso_numero_documento,
      entidad_prestadora.nombre AS entidad_prestadora_nombre,
      institucion.nombre AS institucion_nombre,
      CASE
        WHEN caso.servicio = 1 THEN 'HOSPITALIZACION'
        WHEN caso.servicio = 2 THEN 'URGENCIA'
        WHEN caso.servicio = 3 THEN 'UCI PLENA'
        WHEN caso.servicio = 4 THEN 'UCI INTERNEDIA'
        WHEN caso.servicio = 0 THEN 'NO TIENE'
        WHEN caso.servicio = 5 THEN 'AMBULATORIO'
        ELSE ''
      END AS caso_servicio_value,
      laboratorio.nombre AS laboratorio_nombre,
      DATE(muestra.fecha) AS muestra_fecha,
      DATE(muestra.fecha_recepcion_interna) AS muestra_fecha_recepcion_interna,
      DATE(muestra.fecha_despacho_interna) AS muestra_fecha_despacho_interna,
      muestra.resultado AS muestra_resultado,
      muestra.publico AS muestra_publico,
      CASE
        WHEN muestra.resultado = 1 THEN 'POR DEFINIR'
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'POSITIVO'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'NEGATIVO'
        WHEN muestra.resultado = 4 THEN 'SE SOLICITA NUEVA MUESTRA'
        ELSE ''
      END AS muestra_resultado_value,
      muestra.created_at AS muestra_created_at
    FOO

    query = <<-FOO
      SELECT
      #{select}
      FROM muestras AS muestra
      LEFT JOIN caso_salud_publicas AS caso
      ON muestra.caso_salud_publica_id = caso.id
      LEFT JOIN laboratorios AS laboratorio
      ON muestra.laboratorio_id = laboratorio.id
      LEFT JOIN institucions AS institucion
      ON muestra.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
      ORDER BY muestra.created_at DESC
    FOO

    query_paged = <<-FOO
      #{query}
      LIMIT #{params[:size]}
      OFFSET #{params[:index].to_i - 1}
    FOO
    query_counter = <<-FOO
      SELECT COUNT(*)
      FROM muestras AS muestra
      LEFT JOIN caso_salud_publicas AS caso
      ON muestra.caso_salud_publica_id = caso.id
      LEFT JOIN laboratorios AS laboratorio
      ON muestra.laboratorio_id = laboratorio.id
      LEFT JOIN institucions AS institucion
      ON muestra.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    @registros = ActiveRecord::Base.connection.execute(query_paged)
    @cantidad = ActiveRecord::Base.connection.execute(query_counter)
    @cantidad_registros = @cantidad[0]["count"]
    @cantidad_paginas = (@cantidad_registros / params[:size].to_i).ceil
    render template: "laboratorio/tests/search_pendientes", layout: false
  end

  def despachadas
  end

  def search_despachadas
    where = ""
    where_lines = []
    where_lines << "(muestra.fecha_despacho_interna between ('#{Time.now.in_time_zone("America/Los_Angeles").strftime("%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Time.now.in_time_zone("America/Los_Angeles").strftime("%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')"
    where_lines << "(caso.numero_documento = '#{params[:numero_documento]}')" if !params[:numero_documento].nil? && !params[:numero_documento].empty?
    where_lines << "(caso.municipio_id = #{current_municipio.id})"

    where = where_lines.join(" AND ")
    select = <<-FOO
      muestra.id AS muestra_id,
      caso.numero_oficial AS caso_numero_oficial,
      muestra.fecha_recepcion_interna_laboratorio_asignado AS muestra_fecha_recepcion_interna_laboratorio_asignado,
      caso.id AS caso_id,
      CASE
        WHEN muestra.tipo = 1 THEN 'ASPIRADO TRAQUEAL'
        WHEN muestra.tipo = 2 THEN 'LAVADO BRONCOALVEORAL'
        WHEN muestra.tipo = 3 THEN 'HISOPADO NASOFARINGEO'
        WHEN muestra.tipo = 4 THEN 'ASPIRADO NASOFARIGEO'
        WHEN muestra.tipo = 5 THEN muestra.otro_tipo
        ELSE ''
      END AS muestra_tipo_value,
      CASE
        WHEN muestra.resultado = 1 THEN ''
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'table-danger'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'table-success'
        WHEN muestra.resultado = 4 THEN 'table-warning'
        ELSE ''
      END AS muestra_table_value,
      CASE
        WHEN muestra.estado = 1 THEN 'MUESTRA TOMADA'
        WHEN muestra.estado = 2 THEN 'MUESTRA RECIBIDA POR COORDINADOR'
        WHEN muestra.estado = 3 THEN 'MUESTRA ASIGNADA A LABORATORIO'
        WHEN muestra.estado = 4 THEN 'MUESTRA RECHAZADA'
        WHEN muestra.estado = 5 THEN 'MUESTRA PROCESADA'
        ELSE ''
      END AS muestra_estado_value,
      muestra.estado AS muestra_estado,
      concat(caso.primer_nombre, ' ', caso.segundo_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_apellido) AS caso_nombre_completo,
      CASE
        WHEN caso.edad IS NOT NULL THEN caso.edad
        WHEN caso.fecha_nacimiento IS NOT NULL THEN (date_part('year', AGE(caso.fecha_nacimiento)) )
        ELSE NULL
      END AS caso_edad_value,
      CASE
        WHEN caso.unidad_medida = 1 THEN 'AÑOS'
        WHEN caso.unidad_medida = 2 THEN 'MESES'
        WHEN caso.unidad_medida = 3 THEN 'DIAS'
        ELSE ''
      END AS caso_unidad_medida_value,
      caso.tipo_documento AS caso_tipo_documento,
      caso.numero_documento AS caso_numero_documento,
      entidad_prestadora.nombre AS entidad_prestadora_nombre,
      institucion.nombre AS institucion_nombre,
      CASE
        WHEN caso.servicio = 1 THEN 'HOSPITALIZACION'
        WHEN caso.servicio = 2 THEN 'URGENCIA'
        WHEN caso.servicio = 3 THEN 'UCI PLENA'
        WHEN caso.servicio = 4 THEN 'UCI INTERNEDIA'
        WHEN caso.servicio = 0 THEN 'NO TIENE'
        WHEN caso.servicio = 5 THEN 'AMBULATORIO'
        ELSE ''
      END AS caso_servicio_value,
      laboratorio.nombre AS laboratorio_nombre,
      DATE(muestra.fecha) AS muestra_fecha,
      DATE(muestra.fecha_recepcion_interna) AS muestra_fecha_recepcion_interna,
      DATE(muestra.fecha_despacho_interna) AS muestra_fecha_despacho_interna,
      muestra.resultado AS muestra_resultado,
      muestra.publico AS muestra_publico,
      CASE
        WHEN muestra.resultado = 1 THEN 'POR DEFINIR'
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'POSITIVO'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'NEGATIVO'
        WHEN muestra.resultado = 4 THEN 'SE SOLICITA NUEVA MUESTRA'
        ELSE ''
      END AS muestra_resultado_value,
      muestra.created_at AS muestra_created_at
    FOO

    query = <<-FOO
      SELECT
      #{select}
      FROM muestras AS muestra
      LEFT JOIN caso_salud_publicas AS caso
      ON muestra.caso_salud_publica_id = caso.id
      LEFT JOIN laboratorios AS laboratorio
      ON muestra.laboratorio_id = laboratorio.id
      LEFT JOIN institucions AS institucion
      ON muestra.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
      ORDER BY muestra.created_at DESC
    FOO

    query_paged = <<-FOO
      #{query}
      LIMIT #{params[:size]}
      OFFSET #{params[:index].to_i - 1}
    FOO
    query_counter = <<-FOO
      SELECT COUNT(*)
      FROM muestras AS muestra
      LEFT JOIN caso_salud_publicas AS caso
      ON muestra.caso_salud_publica_id = caso.id
      LEFT JOIN laboratorios AS laboratorio
      ON muestra.laboratorio_id = laboratorio.id
      LEFT JOIN institucions AS institucion
      ON muestra.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    @registros = ActiveRecord::Base.connection.execute(query_paged)
    @cantidad = ActiveRecord::Base.connection.execute(query_counter)
    @cantidad_registros = @cantidad[0]["count"]
    @cantidad_paginas = (@cantidad_registros / params[:size].to_i).ceil
    render template: "laboratorio/tests/search_pendientes", layout: false
  end

  # ESTE DASHBOARD VA PARA EL LABORATORIO COORDINACION PORQUE AQUI HABLAMOS DE RECIBIR, ENTREGAR, PROCESAR
  # ASI QUE ME IMAGINO QUE EL TOTALIZARA POR TODA LA CIUDAD ENTERA
  def dashboard
    hash_caso = {}
    hash_caso["caso_salud_publicas.municipio_id"] = current_municipio.id
    @recibidas_hoy = Muestra.where(fecha_recepcion_interna: Time.now.beginning_of_day..Time.now.end_of_day).includes([:caso_salud_publica]).where(hash_caso).count
    @asignadas_hoy = Muestra.where(fecha_despacho_interna: Time.now.beginning_of_day..Time.now.end_of_day).includes([:caso_salud_publica]).where(hash_caso).count
    @rechazadas_hoy = Muestra.where(fecha_rechazo_interna: Time.now.beginning_of_day..Time.now.end_of_day).includes([:caso_salud_publica]).where(hash_caso).count
    @procesadas_hoy = Muestra.where(fecha_procesado_interna: Time.now.beginning_of_day..Time.now.end_of_day).includes([:caso_salud_publica]).where(hash_caso).count

    @negativos = Muestra.where(fecha_procesado_interna: Time.now.beginning_of_day..Time.now.end_of_day, resultado: 3).includes([:caso_salud_publica]).where(hash_caso).count
    @positivos = Muestra.where(fecha_procesado_interna: Time.now.beginning_of_day..Time.now.end_of_day, resultado: 2, publico: true).includes([:caso_salud_publica]).where(hash_caso).count
    @pendientes = Muestra.where(estado: 3).includes([:caso_salud_publica]).where(hash_caso).count
  end

  def pendientes_v2
  end

  def search_pendientes_v2
    where = ""
    where_lines = []
    where_lines << "(muestra.estado = 2)"
    where_lines << "(caso.numero_documento = '#{params[:numero_documento]}')" if !params[:numero_documento].nil? && !params[:numero_documento].empty?
    where_lines << "(caso.municipio_id = #{current_municipio.id})"

    where = where_lines.join(" AND ")
    select = <<-FOO
      muestra.id AS muestra_id,
      caso.numero_oficial AS caso_numero_oficial,
      muestra.fecha_recepcion_interna_laboratorio_asignado AS muestra_fecha_recepcion_interna_laboratorio_asignado,
      caso.id AS caso_id,
      CASE
        WHEN muestra.tipo = 1 THEN 'ASPIRADO TRAQUEAL'
        WHEN muestra.tipo = 2 THEN 'LAVADO BRONCOALVEORAL'
        WHEN muestra.tipo = 3 THEN 'HISOPADO NASOFARINGEO'
        WHEN muestra.tipo = 4 THEN 'ASPIRADO NASOFARIGEO'
        WHEN muestra.tipo = 5 THEN muestra.otro_tipo
        ELSE ''
      END AS muestra_tipo_value,
      CASE
        WHEN muestra.resultado = 1 THEN ''
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'table-danger'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'table-success'
        WHEN muestra.resultado = 4 THEN 'table-warning'
        ELSE ''
      END AS muestra_table_value,
      CASE
        WHEN muestra.estado = 1 THEN 'MUESTRA TOMADA'
        WHEN muestra.estado = 2 THEN 'MUESTRA RECIBIDA POR COORDINADOR'
        WHEN muestra.estado = 3 THEN 'MUESTRA ASIGNADA A LABORATORIO'
        WHEN muestra.estado = 4 THEN 'MUESTRA RECHAZADA'
        WHEN muestra.estado = 5 THEN 'MUESTRA PROCESADA'
        ELSE ''
      END AS muestra_estado_value,
      muestra.estado AS muestra_estado,
      concat(caso.primer_nombre, ' ', caso.segundo_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_apellido) AS caso_nombre_completo,
      CASE
        WHEN caso.edad IS NOT NULL THEN caso.edad
        WHEN caso.fecha_nacimiento IS NOT NULL THEN (date_part('year', AGE(caso.fecha_nacimiento)) )
        ELSE NULL
      END AS caso_edad_value,
      CASE
        WHEN caso.unidad_medida = 1 THEN 'AÑOS'
        WHEN caso.unidad_medida = 2 THEN 'MESES'
        WHEN caso.unidad_medida = 3 THEN 'DIAS'
        ELSE ''
      END AS caso_unidad_medida_value,
      caso.tipo_documento AS caso_tipo_documento,
      caso.numero_documento AS caso_numero_documento,
      entidad_prestadora.nombre AS entidad_prestadora_nombre,
      institucion.nombre AS institucion_nombre,
      CASE
        WHEN caso.servicio = 1 THEN 'HOSPITALIZACION'
        WHEN caso.servicio = 2 THEN 'URGENCIA'
        WHEN caso.servicio = 3 THEN 'UCI PLENA'
        WHEN caso.servicio = 4 THEN 'UCI INTERNEDIA'
        WHEN caso.servicio = 0 THEN 'NO TIENE'
        WHEN caso.servicio = 5 THEN 'AMBULATORIO'
        ELSE ''
      END AS caso_servicio_value,
      laboratorio.nombre AS laboratorio_nombre,
      DATE(muestra.fecha) AS muestra_fecha,
      DATE(muestra.fecha_recepcion_interna) AS muestra_fecha_recepcion_interna,
      DATE(muestra.fecha_despacho_interna) AS muestra_fecha_despacho_interna,
      muestra.resultado AS muestra_resultado,
      muestra.publico AS muestra_publico,
      CASE
        WHEN muestra.resultado = 1 THEN 'POR DEFINIR'
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'POSITIVO'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'NEGATIVO'
        WHEN muestra.resultado = 4 THEN 'SE SOLICITA NUEVA MUESTRA'
        ELSE ''
      END AS muestra_resultado_value,
      muestra.created_at AS muestra_created_at
    FOO

    query = <<-FOO
      SELECT
      #{select}
      FROM muestras AS muestra
      LEFT JOIN caso_salud_publicas AS caso
      ON muestra.caso_salud_publica_id = caso.id
      LEFT JOIN laboratorios AS laboratorio
      ON muestra.laboratorio_id = laboratorio.id
      LEFT JOIN institucions AS institucion
      ON muestra.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
      ORDER BY muestra.created_at DESC
    FOO

    query_paged = <<-FOO
      #{query}
      LIMIT #{params[:size]}
      OFFSET #{params[:index].to_i - 1}
    FOO
    query_counter = <<-FOO
      SELECT COUNT(*)
      FROM muestras AS muestra
      LEFT JOIN caso_salud_publicas AS caso
      ON muestra.caso_salud_publica_id = caso.id
      LEFT JOIN laboratorios AS laboratorio
      ON muestra.laboratorio_id = laboratorio.id
      LEFT JOIN institucions AS institucion
      ON muestra.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    @registros = ActiveRecord::Base.connection.execute(query_paged)
    @cantidad = ActiveRecord::Base.connection.execute(query_counter)
    @cantidad_registros = @cantidad[0]["count"]
    @cantidad_paginas = (@cantidad_registros / params[:size].to_i).ceil
    render template: "crue/tests/search_pendientes", layout: false
  end

  def download_recibidas
    where = ""
    where_lines = []
    where_lines << "(caso_salud_publicas.municipio_id = #{current_municipio.id})"
    where_lines << "(muestras.fecha_recepcion_interna between ('#{Time.now.in_time_zone("America/Los_Angeles").strftime("%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Time.now.in_time_zone("America/Los_Angeles").strftime("%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')"
    #where_lines << "(muestras.fecha_recepcion_interna between '#{Time.now.strftime("%Y-%m-%d")} 00:00:00' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:00')"
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
      LEFT JOIN municipios as  municipio_residencia
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

  def download_despachadas
    where = ""
    where_lines = []
    where_lines << "(caso_salud_publicas.municipio_id = #{current_municipio.id})"
    where_lines << "(muestras.fecha_despacho_interna between ('#{Time.now.in_time_zone("America/Los_Angeles").strftime("%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Time.now.in_time_zone("America/Los_Angeles").strftime("%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')"
    #where_lines << "(muestras.fecha_despacho_interna between '#{Time.now.strftime("%Y-%m-%d")} 00:00:00' and '#{Time.now.strftime("%Y-%m-%d")} 23:59:00')"
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

  def download
    where = ""
    where_lines = []
    where_lines << "(muestras.laboratorio_id = #{current_usuario.laboratorio.id})" if !current_usuario.laboratorio.coordinacion
    where_lines << "(caso_salud_publicas.id = #{params[:id]})" if !params[:id].nil? && !params[:id].empty?
    where_lines << "(caso_salud_publicas.numero_documento = '#{params[:numero_documento_search]}')" if !params[:numero_documento_search].nil? && !params[:numero_documento_search].empty?
    where_lines << "(caso_salud_publicas.municipio_id = #{current_municipio.id})"
    where_lines << "(caso_salud_publicas.entidad_prestadora_id = #{params[:entidad_prestadora_id]})" if !params[:entidad_prestadora_id].nil? && !params[:entidad_prestadora_id].empty?
    where_lines << "(caso_salud_publicas.sexo = #{params[:sexo]})" if !params[:sexo].nil? && !params[:sexo].empty?
    where_lines << "(caso_salud_publicas.servicio = #{params[:servicio]})" if !params[:servicio].nil? && !params[:servicio].empty?
    where_lines << "(muestras.estado = #{params[:estado]})" if !params[:estado].nil? && !params[:estado].empty?
    where_lines << "(muestras.institucion_id = #{params[:institucion_id]})" if !params[:institucion_id].nil? && !params[:institucion_id].empty?
    where_lines << "(muestras.laboratorio_id = #{params[:laboratorio_id]})" if !params[:laboratorio_id].nil? && !params[:laboratorio_id].empty?
    where_lines << "(muestras.resultado = #{params[:resultado]})" if !params[:resultado].nil? && !params[:resultado].empty?
    where_lines << "(muestras.publico = TRUE)" if params[:resultado] == "2"

    where_lines << "(muestras.fecha_recepcion_interna between ('#{Date.strptime(params[:start_date_recibido], "%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Date.strptime(params[:end_date_recibido], "%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')" if !params[:start_date_recibido].nil? && !params[:start_date_recibido].empty? && !params[:end_date_recibido].nil? && !params[:end_date_recibido].empty?
    where_lines << "(muestras.fecha_despacho_interna between ('#{Date.strptime(params[:start_date_enviado], "%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Date.strptime(params[:end_date_enviado], "%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')" if !params[:start_date_enviado].nil? && !params[:start_date_enviado].empty? && !params[:end_date_enviado].nil? && !params[:end_date_enviado].empty?
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
