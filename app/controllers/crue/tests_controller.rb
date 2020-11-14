# encoding: UTF-8

class Crue::TestsController < ApplicationController
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
    where_lines << "(muestra.laboratorio_id = #{params[:laboratorio_id]})" if !params[:laboratorio_id].nil? && !params[:laboratorio_id].empty?
    where_lines << "(muestra.resultado = #{params[:resultado]})" if !params[:resultado].nil? && !params[:resultado].empty?
    where_lines << "(caso.publico = TRUE)" if params[:resultado] == "2"
    where_lines << "(muestra.estado = #{params[:estado]})" if !params[:estado].nil? && !params[:estado].empty?
    where_lines << "(muestra.fecha_recepcion_interna between ('#{Date.strptime(params[:start_date_recibido], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date_recibido], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date_recibido].nil? && !params[:start_date_recibido].empty? && !params[:end_date_recibido].nil? && !params[:end_date_recibido].empty?
    where_lines << "(muestra.fecha_despacho_interna between ('#{Date.strptime(params[:start_date_enviado], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date_enviado], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date_enviado].nil? && !params[:start_date_enviado].empty? && !params[:end_date_enviado].nil? && !params[:end_date_enviado].empty?
    where_lines << "(caso.numero_oficial = #{params[:numero_oficial]})" if !params[:numero_oficial].nil? && !params[:numero_oficial].empty?
    where_lines << "(caso.id = #{params[:id]})" if !params[:id].nil? && !params[:id].empty?
    where_lines << "(caso.numero_documento = '#{params[:numero_documento]}')" if !params[:numero_documento].nil? && !params[:numero_documento].empty?
    where_lines << "(caso.entidad_prestadora_id = #{params[:entidad_prestadora_id]})" if !params[:entidad_prestadora_id].nil? && !params[:entidad_prestadora_id].empty?
    where_lines << "(caso.sexo = #{params[:sexo]})" if !params[:sexo].nil? && !params[:sexo].empty?
    where_lines << "(caso.servicio = #{params[:servicio]})" if !params[:servicio].nil? && !params[:servicio].empty?
    where_lines << "(caso.primer_nombre ILIKE '%#{params[:primer_nombre]}%')" if !params[:primer_nombre].nil? && !params[:primer_nombre].empty?
    where_lines << "(caso.primer_apellido ILIKE '%#{params[:primer_apellido]}%')" if !params[:primer_apellido].nil? && !params[:primer_apellido].empty?

    if current_usuario.municipio_alterno
      where_lines << "(caso.municipio_origen_id = #{current_municipio.id})"
    elsif current_usuario.municipio
      where_lines << "(caso.municipio_id = #{current_municipio.id})"
    end

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
      concat(caso.primer_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_nombre, ' ', caso.segundo_apellido) AS caso_nombre_completo,
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
      muestra.created_at
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

  def por_aprobar
  end

  def search_por_aprobar
    where = ""
    where_lines = []
    if current_usuario.municipio_alterno
      where_lines << "(caso.municipio_origen_id = #{current_municipio.id})"
    elsif current_usuario.municipio
      where_lines << "(caso.municipio_id = #{current_municipio.id})"
    end
    where_lines << "(muestra.resultado = 2)"
    where_lines << "(muestra.publico = FALSE)"
    where_lines << "(caso.numero_documento = #{params[:numero_documento].strip})" if params[:numero_documento] && params[:numero_documento] != ""
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
      concat(caso.primer_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_nombre, ' ', caso.segundo_apellido) AS caso_nombre_completo,
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
      muestra.created_at
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
      LEFT JOIN archivos AS archivo
      ON archivo.muestra_id = muestra.id
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
      ON caso.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      LEFT JOIN archivos AS archivo
      ON archivo.muestra_id = muestra.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    @registros = ActiveRecord::Base.connection.execute(query_paged)
    @cantidad = ActiveRecord::Base.connection.execute(query_counter)
    @cantidad_registros = @cantidad[0]["count"]
    @cantidad_paginas = (@cantidad_registros / params[:size].to_i).ceil
    render template: "crue/tests/search_pendientes", layout: false
  end

  def inconsistencias
  end

  def search_inconsistencias
    hash_caso = {}
    hash_caso["caso_salud_publicas.numero_documento"] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
    if current_usuario.municipio_alterno
      hash_caso["caso_salud_publicas.municipio_origen_id"] = current_municipio.id
    elsif current_usuario.municipio
      hash_caso["caso_salud_publicas.municipio_id"] = current_municipio.id
    end
    @muestras = Muestra.where(resultado: [2, 3]).where.not(pdf_puntaje: nil).where("muestras.pdf_puntaje < 6").includes([:caso_salud_publica]).where(hash_caso)
    @muestras = @muestras.order("muestras.created_at DESC").paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @muestras.total_pages
    @cantidad_registros = @muestras.count
    render template: "crue/tests/search_inconsistencias", layout: false
  end

  def aprobar
    @muestra = Muestra.find_by_id params[:id]
    @caso = @muestra.caso_salud_publica
  end

  def do_aprobar
    @muestra = Muestra.find_by_id params[:id]
    @caso = @muestra.caso_salud_publica
    @caso.numero_oficial = params[:numero_oficial]
    @muestra.publico = true
    @caso.publico = true if @caso
    @muestra.save!
    @caso.save! if @caso
  end

  def recibidas
  end

  def search_recibidas
    where = ""
    where_lines = []
    if current_usuario.municipio_alterno
      where_lines << "(caso.municipio_origen_id = #{current_municipio.id})"
    elsif current_usuario.municipio
      where_lines << "(caso.municipio_id = #{current_municipio.id})"
    end
    where_lines << "(caso.numero_documento = #{params[:numero_documento].strip})" if params[:numero_documento] && params[:numero_documento] != ""
    where_lines << "(muestra.fecha_recepcion_interna between ('#{Time.now.strftime("%Y-%m-%d")} 05:00:00') and ('#{(Time.now + 1.days).strftime("%Y-%m-%d")} 04:59:59.999999'))"
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
      concat(caso.primer_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_nombre, ' ', caso.segundo_apellido) AS caso_nombre_completo,
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
      muestra.created_at
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
      LEFT JOIN archivos AS archivo
      ON archivo.muestra_id = muestra.id
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
      ON caso.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      LEFT JOIN archivos AS archivo
      ON archivo.muestra_id = muestra.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    @registros = ActiveRecord::Base.connection.execute(query_paged)
    @cantidad = ActiveRecord::Base.connection.execute(query_counter)
    @cantidad_registros = @cantidad[0]["count"]
    @cantidad_paginas = (@cantidad_registros / params[:size].to_i).ceil
    render template: "crue/tests/search_pendientes", layout: false
  end

  def despachadas
  end

  def search_despachadas
    where = ""
    where_lines = []
    if current_usuario.municipio_alterno
      where_lines << "(caso.municipio_origen_id = #{current_municipio.id})"
    elsif current_usuario.municipio
      where_lines << "(caso.municipio_id = #{current_municipio.id})"
    end
    where_lines << "(caso.numero_documento = #{params[:numero_documento].strip})" if params[:numero_documento] && params[:numero_documento] != ""
    where_lines << "(muestra.fecha_despacho_interna between ('#{Time.now.strftime("%Y-%m-%d")} 05:00:00') and ('#{(Time.now + 1.days).strftime("%Y-%m-%d")} 04:59:59.999999'))"
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
      concat(caso.primer_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_nombre, ' ', caso.segundo_apellido) AS caso_nombre_completo,
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
      muestra.created_at
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
      LEFT JOIN archivos AS archivo
      ON archivo.muestra_id = muestra.id
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
      ON caso.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      LEFT JOIN archivos AS archivo
      ON archivo.muestra_id = muestra.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    @registros = ActiveRecord::Base.connection.execute(query_paged)
    @cantidad = ActiveRecord::Base.connection.execute(query_counter)
    @cantidad_registros = @cantidad[0]["count"]
    @cantidad_paginas = (@cantidad_registros / params[:size].to_i).ceil
    render template: "crue/tests/search_pendientes", layout: false
  end

  def pendientes_v2
  end

  def search_pendientes_v2
    where = ""
    where_lines = []
    where_lines << "(caso.municipio_id = #{current_municipio.id})"
    where_lines << "(caso.numero_documento = #{params[:numero_documento].strip})" if params[:numero_documento] && params[:numero_documento] != ""
    where_lines << "(muestra.estado = 2)"
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
      concat(caso.primer_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_nombre, ' ', caso.segundo_apellido) AS caso_nombre_completo,
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
      muestra.created_at
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
      LEFT JOIN archivos AS archivo
      ON archivo.muestra_id = muestra.id
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
      ON caso.institucion_id = institucion.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      LEFT JOIN archivos AS archivo
      ON archivo.muestra_id = muestra.id
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
    if current_usuario.municipio_alterno
      where_lines << "(caso_salud_publicas.municipio_origen_id = #{current_municipio.id})"
    elsif current_usuario.municipio
      where_lines << "(caso_salud_publicas.municipio_id = #{current_municipio.id})"
    end
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
      ON caso_salud_publicas.institucion_id = institucions.id
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
      ORDER BY muestra.created_at DESC
    FOO
    puts where_lines.join(" AND ")
    data = copy_to_string(query)
    send_data data, :filename => "dump_muestras.csv"
  end

  def download_despachadas
    where = ""
    where_lines = []
    if current_usuario.municipio_alterno
      where_lines << "(caso_salud_publicas.municipio_origen_id = #{current_municipio.id})"
    elsif current_usuario.municipio
      where_lines << "(caso_salud_publicas.municipio_id = #{current_municipio.id})"
    end
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
      ORDER BY muestra.created_at DESC
    FOO
    puts where_lines.join(" AND ")
    data = copy_to_string(query)
    send_data data, :filename => "dump_muestras.csv"
  end

  def download
    where = ""
    where_lines = []
    where_lines << "(caso_salud_publicas.id = #{params[:id]})" if !params[:id].nil? && !params[:id].empty?
    where_lines << "(caso_salud_publicas.numero_documento = '#{params[:numero_documento_search]}')" if !params[:numero_documento_search].nil? && !params[:numero_documento_search].empty?
    if current_usuario.municipio_alterno
      where_lines << "(caso_salud_publicas.municipio_origen_id = #{current_municipio.id})"
    elsif current_usuario.municipio
      where_lines << "(caso_salud_publicas.municipio_id = #{current_municipio.id})"
    end
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
      ORDER BY muestras.created_at DESC
    FOO
    puts where_lines.join(" AND ")
    data = copy_to_string(query)
    send_data data, :filename => "dump_muestras.csv"
  end

  def do_busqueda_masiva
    if params[:numeros_documento] && !params[:numeros_documento].empty?
      numeros_documento = params[:numeros_documento].strip.tr("\r", "").split("\n")
      numeros_documento = numeros_documento.map { |n| "'#{n}'" }.join(",")
    elsif params[:archivo]
      numeros_documento = File.read(params[:archivo].path).strip.tr("\r", "").split("\n")
      numeros_documento = numeros_documento.map { |n| "'#{n}'" }.join(",")
    else
      numeros_documento = ""
    end
    where = ""
    where_lines = []
    where_lines << "(caso_salud_publicas.municipio_id = #{current_municipio.id})"
    where_lines << "(caso_salud_publicas.numero_documento IN (#{numeros_documento}) )" if numeros_documento != ""

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
      ORDER BY muestra.created_at DESC
    FOO
    puts where_lines.join(" AND ")
    data = copy_to_string(query)
    send_data data, :filename => "dump_muestras.csv"
  end

  def sismuestra_logs
    @flag = SismuestraFlag.last
  end
end
