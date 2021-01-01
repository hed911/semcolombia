# encoding: UTF-8

class Laboratorio::ResultadosController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def search
    where = ""
    where_lines = []
    where_lines << "(caso.laboratorio_id = #{current_usuario.laboratorio.id})" if !current_usuario.laboratorio.coordinacion
    where_lines << "(caso.numero_documento = '#{params[:numero_documento].strip}')" if params[:numero_documento] && params[:numero_documento] != ""
    where_lines << "(caso.municipio_id = #{current_municipio.id})"
    where = where_lines.join(" AND ")

    select = <<-FOO
      muestra.id AS muestra_id,
      CASE
        WHEN muestra.resultado = 1 THEN ''
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'table-danger'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'table-success'
        WHEN muestra.resultado = 4 THEN 'table-warning'
        ELSE ''
      END AS muestra_table_value,
      laboratorio.nombre AS laboratorio_nombre,
      muestra.resultado AS muestra_resultado,
      CASE
        WHEN muestra.resultado = 1 THEN 'POR DEFINIR'
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'POSITIVO'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'NEGATIVO'
        WHEN muestra.resultado = 4 THEN 'SE SOLICITA NUEVA MUESTRA'
        ELSE ''
      END AS muestra_resultado_value,
      DATE(muestra.fecha) AS muestra_fecha,
      DATE(muestra.fecha_realizacion) AS muestra_fecha_realizacion,
      archivo.uuid AS archivo_uuid,
      caso.id AS caso_id,
      caso.numero_oficial AS caso_numero_oficial,
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
      muestra.created_at AS created_at
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
    render layout: false
  end

  def searchxxx
    #if params[:numero_documento] && params[:numero_documento] != ""
    hash = {}
    hash[:laboratorio] = current_usuario.laboratorio if !current_usuario.laboratorio.coordinacion
    hash_caso = {}
    hash_caso["caso_salud_publicas.numero_documento"] = params[:numero_documento].strip if params[:numero_documento] && params[:numero_documento] != ""
    hash_caso["caso_salud_publicas.municipio_id"] = current_municipio.id

    @muestras = Muestra.where(hash).includes([:caso_salud_publica]).where(hash_caso)
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
    where = ""
    where_lines = []
    where_lines << "(caso.municipio_id = #{current_municipio.id})"
    where_lines << "(caso.numero_documento = #{params[:numero_documento].strip})" if params[:numero_documento] && params[:numero_documento] != ""
    where_lines << "(caso.estado <> 4 AND caso.estado <> 5)"
    where_lines << "(caso.laboratorio_id = #{current_usuario.laboratorio.id})"

    where_lines << "(muestra.fecha_procesado_interna between ('#{Date.strptime(params[:start_date], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date].nil? && !params[:start_date].empty? && !params[:end_date].nil? && !params[:end_date].empty?
    where = where_lines.join(" AND ")

    select = <<-FOO
      muestra.id AS muestra_id,
      CASE
        WHEN muestra.resultado = 1 THEN ''
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'table-danger'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'table-success'
        WHEN muestra.resultado = 4 THEN 'table-warning'
        ELSE ''
      END AS muestra_table_value,
      laboratorio.nombre AS laboratorio_nombre,
      muestra.resultado AS muestra_resultado,
      CASE
        WHEN muestra.resultado = 1 THEN 'POR DEFINIR'
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'POSITIVO'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'NEGATIVO'
        WHEN muestra.resultado = 4 THEN 'SE SOLICITA NUEVA MUESTRA'
        ELSE ''
      END AS muestra_resultado_value,
      DATE(muestra.fecha) AS muestra_fecha,
      DATE(muestra.fecha_realizacion) AS muestra_fecha_realizacion,
      archivo.uuid AS archivo_uuid,
      caso.id AS caso_id,
      caso.numero_oficial AS caso_numero_oficial,
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
      muestra.created_at AS created_at
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
    render layout: false
  end

  def hoy
  end

  def search_hoy
    where = ""
    where_lines = []
    where_lines << "(caso.municipio_id = #{current_municipio.id})"
    where_lines << "(caso.numero_documento = #{params[:numero_documento].strip})" if params[:numero_documento] && params[:numero_documento] != ""
    if params[:tipo] == "positivo"
      where_lines << "(muestra.resultado = 2)"
      where_lines << "(muestra.publico = TRUE)"
    elsif params[:tipo] == "negativo"
      where_lines << "(muestra.resultado = 3)"
    elsif params[:tipo] == "no_se_pudo"
      where_lines << "(muestra.resultado = 4)"
    end
    where_lines << "(muestra.fecha_procesado_interna between ('#{Date.strptime(params[:start_date], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date].nil? && !params[:start_date].empty? && !params[:end_date].nil? && !params[:end_date].empty?
    where = where_lines.join(" AND ")

    select = <<-FOO
      muestra.id AS muestra_id,
      CASE
        WHEN muestra.resultado = 1 THEN ''
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'table-danger'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'table-success'
        WHEN muestra.resultado = 4 THEN 'table-warning'
        ELSE ''
      END AS muestra_table_value,
      laboratorio.nombre AS laboratorio_nombre,
      muestra.resultado AS muestra_resultado,
      CASE
        WHEN muestra.resultado = 1 THEN 'POR DEFINIR'
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'POSITIVO'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'NEGATIVO'
        WHEN muestra.resultado = 4 THEN 'SE SOLICITA NUEVA MUESTRA'
        ELSE ''
      END AS muestra_resultado_value,
      DATE(muestra.fecha) AS muestra_fecha,
      DATE(muestra.fecha_realizacion) AS muestra_fecha_realizacion,
      archivo.uuid AS archivo_uuid,
      caso.id AS caso_id,
      caso.numero_oficial AS caso_numero_oficial,
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
      muestra.created_at AS created_at
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
    render template: "crue/resultados/search", layout: false
  end
end
