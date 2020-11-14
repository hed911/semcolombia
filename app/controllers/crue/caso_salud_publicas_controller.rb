# encoding: UTF-8

class Crue::CasoSaludPublicasController < ApplicationController
  before_action :authenticate_usuario!
  include PostgresqlDumper

  def index
    @instituciones = Institucion.where(activo: true, municipio: current_municipio).order("nombre ASC")
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
    @countries = Country.all.order("nombre ASC")
    @usuarios = []
    Usuario.where(es_super_admin: false, municipio: current_municipio, entidad_prestadora: nil, institucion: nil).each do |usuario|
      @usuarios << usuario if usuario.roles_array.include?(ROLES[3])
    end
  end

  def actuales
    @operarios = Operario.all.order("nombre ASC")
    @instituciones = Institucion.where(activo: true, municipio: current_municipio).order("nombre ASC")
  end

  def search_actuales
    where = ""
    where_lines = []
    where_lines << "(caso.estado = #{ESTADO_SP_VIGENTE})"
    where_lines << "(caso.municipio_id = #{current_municipio.id})" if !current_usuario.municipio_alterno
    where_lines << "(caso.municipio_origen_id = '#{current_municipio.id}')" if current_usuario.municipio_alterno

    where = where_lines.join(" AND ")
    select = <<-FOO
      CASE
        WHEN caso.triage = 1 THEN 'table-success'
        WHEN caso.triage = 2 THEN 'table-warning'
        WHEN caso.triage = 3 THEN 'table-danger'
        ELSE ''
      END AS caso_table_value,
      caso.numero_oficial AS caso_numero_oficial,
      caso.id AS caso_id,
      concat(caso.primer_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_nombre, ' ', caso.segundo_apellido) AS caso_nombre_completo,
      (caso.nivel + 1) AS caso_nivel,
      '-' AS caso_cantidad_contactos,
      '-' AS caso_cantidad_muestras,
      DATE(caso.fecha_investigacion) AS caso_fecha_investigacion,
      DATE(caso.fecha_actualizacion_iec) AS caso_fecha_actualizacion_iec,
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
      CASE
        WHEN caso.sexo = 1 THEN 'M'
        WHEN caso.sexo = 2 THEN 'F'
        ELSE ''
      END AS caso_sexo_value,
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
      CASE
        WHEN caso.servicio_crue = 1 THEN 'GENERAL PEDÍATRICA'
        WHEN caso.servicio_crue = 2 THEN 'GENERAR ADULTOS'
        WHEN caso.servicio_crue = 3 THEN 'UCI 1/2 ADULTOS'
        WHEN caso.servicio_crue = 4 THEN 'UCI 1/2 NEONATAL'
        WHEN caso.servicio_crue = 5 THEN 'UCI 1/2 PEDIÁTRICO'
        WHEN caso.servicio_crue = 6 THEN 'UCI ADULTOS'
        WHEN caso.servicio_crue = 7 THEN 'UCI NEONATAL'
        WHEN caso.servicio_crue = 8 THEN 'UCI PEDIÁTRICO'
        WHEN caso.servicio_crue = 9 THEN 'EN CASA'
        WHEN caso.servicio_crue = 10 THEN 'FALLECIDO'
        ELSE ''
      END AS caso_servicio_crue_value,
      CASE
        WHEN usuario.entidad_prestadora_id IS NOT NULL THEN entidad_prestadora_usuario.nombre
        WHEN caso.institucion_id IS NOT NULL THEN institucion.nombre
        WHEN usuario.institucion_id IS NOT NULL THEN institucion_usuario.nombre
        WHEN usuario.laboratorio_id IS NOT NULL THEN laboratorio.nombre
        ELSE 'SEC SALUD'
      END AS caso_origen_value,
      concat(usuario.primer_nombre, ' ', usuario.primer_apellido, ' ', usuario.segundo_nombre, ' ', usuario.segundo_apellido) AS usuario_nombre_completo,
      CASE
        WHEN caso.estado = 1 THEN 'VIGENTE'
        WHEN caso.estado = 1 THEN 'CERRADO'
        ELSE ''
      END AS caso_estado_value,
      CASE
        WHEN caso.estado_seguimiento = 1 THEN 'EN SEGUIMIENTO'
        WHEN caso.estado_seguimiento = 2 THEN 'REQUIERE HOSPITALIZACION'
        WHEN caso.estado_seguimiento = 3 THEN 'RESUELTO SATISFACTORIAMENTE'
        WHEN caso.estado_seguimiento = 4 THEN 'NO CUMPLE CON DEFINICION DE CASO'
        WHEN caso.estado_seguimiento = 5 THEN 'AISLAMIENTO EN CASA'
        WHEN caso.estado_seguimiento = 6 THEN 'INTERNACION'
        WHEN caso.estado_seguimiento = 7 THEN 'FALLECIDO'
        WHEN caso.estado_seguimiento = 8 THEN 'OBSERVACION'
        WHEN caso.estado_seguimiento = 9 THEN 'SEGUIMIENTO FINALIZADO'
        ELSE 'SEC SALUD'
      END AS caso_estado_seguimiento_value,
      CASE
        WHEN caso.fallecido = TRUE THEN 'FALLECIDO'
        ELSE 'VIVO'
      END AS caso_fallecido_value,
      CASE
        WHEN caso.responsable_investigacion_id IS NOT NULL THEN 'REALIZADO'
        ELSE 'PENDIENTE'
      END AS caso_iec_realizado_value,
      caso.id AS caso_id,
      caso.estado AS caso_estado
    FOO

    query = <<-FOO
      SELECT
      #{select}
      FROM caso_salud_publicas AS caso
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      LEFT JOIN institucions AS institucion
      ON caso.institucion_id = institucion.id
      LEFT JOIN usuarios AS usuario
      ON caso.usuario_id = usuario.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora_usuario
      ON usuario.entidad_prestadora_id = entidad_prestadora_usuario.id
      LEFT JOIN institucions AS institucion_usuario
      ON usuario.institucion_id = institucion_usuario.id
      LEFT JOIN laboratorios AS laboratorio
      ON caso.laboratorio_id = laboratorio.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
      ORDER BY caso.created_at DESC
    FOO

    query_paged = <<-FOO
      #{query}
      LIMIT #{params[:size]}
      OFFSET #{params[:index].to_i - 1}
    FOO
    query_counter = <<-FOO
      SELECT COUNT(*)
      FROM caso_salud_publicas AS caso
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      LEFT JOIN institucions AS institucion
      ON caso.institucion_id = institucion.id
      LEFT JOIN usuarios AS usuario
      ON caso.usuario_id = usuario.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora_usuario
      ON usuario.entidad_prestadora_id = entidad_prestadora_usuario.id
      LEFT JOIN institucions AS institucion_usuario
      ON usuario.institucion_id = institucion_usuario.id
      LEFT JOIN laboratorios AS laboratorio
      ON caso.laboratorio_id = laboratorio.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    @registros = ActiveRecord::Base.connection.execute(query_paged)
    @cantidad = ActiveRecord::Base.connection.execute(query_counter)
    @cantidad_registros = @cantidad[0]["count"]
    @cantidad_paginas = (@cantidad_registros / params[:size].to_i).ceil
    render template: "crue/caso_salud_publicas/search", layout: false
  end

  def edit
    @caso = CasoSaludPublica.find_by_id params[:id]
    @llamada = Llamada.find_by_id params[:llamada_id]
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
    @instituciones = Institucion.where(activo: true, municipio: current_municipio).order("nombre ASC")
    @countries = Country.all.order("nombre ASC")
    @departamentos = Departamento.all.order("nombre ASC")
    @colombia = Country.find_by_codigo("co")
    @municipios = @caso.departamento_origen.nil? ? [] : @caso.departamento_origen.municipios.order("nombre ASC")
    @barrios = @caso.municipio_origen.nil? ? [] : @caso.municipio_origen.barrios.order("nombre ASC")
    @municipios_contacto_uno = @caso.departamento_contacto_uno.nil? ? [] : @caso.departamento_contacto_uno.municipios.order("nombre ASC")
    render layout: false
  end

  def edit_iec
    @caso = CasoSaludPublica.find_by_id params[:id]
    @llamada = Llamada.find_by_id params[:llamada_id]
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
    @instituciones = Institucion.where(activo: true, municipio: current_municipio).order("nombre ASC")
    @countries = Country.all.order("nombre ASC")
    @departamentos = Departamento.all.order("nombre ASC")
    @colombia = Country.find_by_codigo("co")
    @municipios = @caso.departamento_origen.nil? ? [] : @caso.departamento_origen.municipios.order("nombre ASC")
    @barrios = @caso.municipio_origen.nil? ? [] : @caso.municipio_origen.barrios.order("nombre ASC")
    @municipios_contacto_uno = @caso.departamento_contacto_uno.nil? ? [] : @caso.departamento_contacto_uno.municipios.order("nombre ASC")
    render layout: false
  end

  def new
    @datetime_object = Time.now
    @datetime = @datetime_object.strftime("%Y-%m-%dT%T")

    @llamada = Llamada.find_by_id params[:llamada_id]
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
    @instituciones = Institucion.where(activo: true, municipio: current_municipio).order("nombre ASC")
    @countries = Country.all.order("nombre ASC")
    @departamentos = Departamento.all.order("nombre ASC")
    @colombia = Country.find_by_codigo("co")
    @municipios = current_municipio.departamento.municipios.order("nombre ASC")
    @barrios = current_municipio.barrios.order("nombre ASC")
    render layout: false
  end

  def create
    if CasoSaludPublica.find_by_tipo_documento_and_numero_documento_and_municipio_id(params[:tipo_documento], params[:numero_documento], current_municipio.id)
      @error = "Ya existe un registro con el numero de documento dado"
      return
    end
    @caso = CasoSaludPublica.create!
    @caso.primer_nombre = params[:primer_nombre]
    @caso.primer_apellido = params[:primer_apellido]
    @caso.segundo_nombre = params[:segundo_nombre]
    @caso.segundo_apellido = params[:segundo_apellido]
    @caso.fecha_nacimiento = params[:fecha_nacimiento]
    @caso.edad = params[:edad]
    @caso.unidad_medida = params[:unidad_medida]
    @caso.email = params[:email]
    @caso.regimen = params[:regimen]
    @caso.tipo_documento = params[:tipo_documento]
    @caso.numero_documento = params[:numero_documento].strip
    @caso.sexo = params[:sexo]
    @caso.tipo_sanguineo = params[:tipo_sanguineo]
    @caso.entidad_prestadora = EntidadPrestadora.find_by_id(params[:entidad_prestadora_id])
    @caso.institucion = Institucion.find_by_id(params[:institucion_id])
    @caso.country = Country.find_by_id(params[:country_id])

    @caso.departamento = current_municipio.departamento
    @caso.municipio = current_municipio

    @caso.departamento_origen = Departamento.find_by_id(params[:departamento_id])
    @caso.municipio_origen = Municipio.find_by_id(params[:municipio_id])

    @caso.barrio = Barrio.find_by_id(params[:barrio_id])
    @caso.direccion = params[:direccion]
    @caso.telefono = params[:telefono]
    @caso.observacion = params[:observacion].tr("\n", "").tr("\r", "").tr(";", ",")
    @caso.country_uno = Country.find_by_id(params[:country_uno_id])
    @caso.country_dos = Country.find_by_id(params[:country_dos_id])
    @caso.primer_nombre_contacto_uno = params[:primer_nombre_contacto_uno]
    @caso.primer_apellido_contacto_uno = params[:primer_apellido_contacto_uno]
    @caso.segundo_nombre_contacto_uno = params[:segundo_nombre_contacto_uno]
    @caso.segundo_apellido_contacto_uno = params[:segundo_apellido_contacto_uno]
    @caso.country_contacto_uno = Country.find_by_id(params[:country_id_contacto_uno])
    @caso.departamento_contacto_uno = Departamento.find_by_id(params[:departamento_id_contacto_uno])
    @caso.municipio_contacto_uno = Municipio.find_by_id(params[:municipio_id_contacto_uno])
    @caso.direccion_contacto_uno = params[:direccion_contacto_uno]
    @caso.telefono_contacto_uno = params[:telefono_contacto_uno]
    @caso.diagnostico_principal = Diagnostico.find_by_id("25168")
    @caso.codigo_evento = params[:codigo_evento]
    @caso.clasificacion = params[:clasificacion]
    @caso.servicio = params[:servicio]
    @caso.tipo_contagio = params[:tipo_contagio]

    @caso.sintoma_covid_fiebre = params[:sintoma_covid_fiebre] == "1"
    @caso.sintoma_covid_tos = params[:sintoma_covid_tos] == "1"
    @caso.sintoma_covid_dificultad_respiratoria = params[:sintoma_covid_dificultad_respiratoria] == "1"
    @caso.sintoma_covid_secrecion_nasal = params[:sintoma_covid_secrecion_nasal] == "1"
    @caso.sintoma_covid_malestar_general = params[:sintoma_covid_malestar_general] == "1"
    @caso.sintoma_covid_dolor_muscular = params[:sintoma_covid_dolor_muscular] == "1"
    @caso.sintoma_covid_diarrea = params[:sintoma_covid_diarrea] == "1"
    @caso.sintoma_covid_dolor_abdominal = params[:sintoma_covid_dolor_abdominal] == "1"
    @caso.sintoma_covid_dolor_toraxico = params[:sintoma_covid_dolor_toraxico] == "1"
    @caso.sintoma_covid_vomito = params[:sintoma_covid_vomito] == "1"
    @caso.relacionamiento_con_infectados = params[:relacionamiento_con_infectados] == "1"
    @caso.ha_estado_fuera_del_pais = params[:ha_estado_fuera_del_pais] == "1"
    @caso.es_trabajador_de_salud = params[:es_trabajador_de_salud] == "1"
    @caso.fallecido = params[:fallecido] == "1"

    @caso.ciudad_uno = params[:ciudad_uno]
    @caso.ciudad_dos = params[:ciudad_dos]
    @caso.fecha_ingreso_uno = params[:fecha_ingreso_uno]
    @caso.fecha_ingreso_dos = params[:fecha_ingreso_dos]
    @caso.fecha_salida_uno = params[:fecha_salida_uno]
    @caso.fecha_salida_dos = params[:fecha_salida_dos]
    @caso.conglomerado = params[:conglomerado]

    @caso.nivel = 0
    @caso.estado = ESTADO_SP_VIGENTE
    @caso.estado_seguimiento = 1
    @caso.estado_enfermedad = 1
    @caso.fecha_actualizacion_estado_enfermedad = Time.now
    @caso.usuario = current_usuario
    @caso.save!
    @caso.calculate_triage
    @caso.created_at = Time.strptime(params[:created_at], "%Y-%m-%dT%T") if !params[:created_at].nil?
    @caso.save!

    @llamada = Llamada.find_by_id(params[:llamada_id])
    if @llamada
      @llamada.caso_salud_publica = @caso
      @llamada.save!
    end
  end

  def show
    @caso = CasoSaludPublica.find_by_id params[:id]
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
    @instituciones = Institucion.where(activo: true, municipio: current_municipio).order("nombre ASC")
    @countries = Country.all.order("nombre ASC")
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
    @departamentos = Departamento.all.order("nombre ASC")
    @colombia = Country.find_by_codigo("co")
    @municipios = @caso.departamento_origen.nil? ? [] : @caso.departamento_origen.municipios.order("nombre ASC")
    @barrios = @caso.municipio_origen.nil? ? [] : @caso.municipio_origen.barrios.order("nombre ASC")
    @municipios_contacto_uno = @caso.departamento_contacto_uno.nil? ? [] : @caso.departamento_contacto_uno.municipios.order("nombre ASC")
    render layout: false
  end

  def update
    @caso = CasoSaludPublica.find_by_id params[:id]
    repeated_caso = CasoSaludPublica.find_by_tipo_documento_and_numero_documento_and_municipio_id(params[:tipo_documento], params[:numero_documento], current_municipio.id)
    if repeated_caso && repeated_caso.id != @caso.id
      @error = "Ya existe un registro con el numero de documento dado"
      return
    end
    @caso.primer_nombre = params[:primer_nombre]
    @caso.primer_apellido = params[:primer_apellido]
    @caso.segundo_nombre = params[:segundo_nombre]
    @caso.segundo_apellido = params[:segundo_apellido]
    @caso.fecha_nacimiento = params[:fecha_nacimiento]
    @caso.edad = params[:edad]
    @caso.unidad_medida = params[:unidad_medida]
    @caso.email = params[:email]
    @caso.regimen = params[:regimen]
    @caso.tipo_documento = params[:tipo_documento]
    @caso.numero_documento = params[:numero_documento].strip
    @caso.sexo = params[:sexo]
    @caso.tipo_sanguineo = params[:tipo_sanguineo]
    @caso.entidad_prestadora = EntidadPrestadora.find_by_id(params[:entidad_prestadora_id])
    @caso.institucion = Institucion.find_by_id(params[:institucion_id])
    @caso.country = Country.find_by_id(params[:country_id])

    @caso.departamento = current_municipio.departamento
    @caso.municipio = current_municipio

    @caso.departamento_origen = Departamento.find_by_id(params[:departamento_id])
    @caso.municipio_origen = Municipio.find_by_id(params[:municipio_id])

    @caso.barrio = Barrio.find_by_id(params[:barrio_id])
    @caso.direccion = params[:direccion]
    @caso.telefono = params[:telefono]
    @caso.observacion = params[:observacion].tr("\n", "").tr("\r", "").tr(";", ",")
    @caso.country_uno = Country.find_by_id(params[:country_uno_id])
    @caso.country_dos = Country.find_by_id(params[:country_dos_id])
    @caso.primer_nombre_contacto_uno = params[:primer_nombre_contacto_uno]
    @caso.primer_apellido_contacto_uno = params[:primer_apellido_contacto_uno]
    @caso.segundo_nombre_contacto_uno = params[:segundo_nombre_contacto_uno]
    @caso.segundo_apellido_contacto_uno = params[:segundo_apellido_contacto_uno]
    @caso.country_contacto_uno = Country.find_by_id(params[:country_id_contacto_uno])
    @caso.departamento_contacto_uno = Departamento.find_by_id(params[:departamento_id_contacto_uno])
    @caso.municipio_contacto_uno = Municipio.find_by_id(params[:municipio_id_contacto_uno])
    @caso.direccion_contacto_uno = params[:direccion_contacto_uno]
    @caso.telefono_contacto_uno = params[:telefono_contacto_uno]
    @caso.diagnostico_principal = Diagnostico.find_by_id("25168")
    @caso.codigo_evento = params[:codigo_evento]
    @caso.clasificacion = params[:clasificacion]
    @caso.servicio = params[:servicio]
    @caso.tipo_contagio = params[:tipo_contagio]

    @caso.sintoma_covid_fiebre = params[:sintoma_covid_fiebre] == "1"
    @caso.sintoma_covid_tos = params[:sintoma_covid_tos] == "1"
    @caso.sintoma_covid_dificultad_respiratoria = params[:sintoma_covid_dificultad_respiratoria] == "1"
    @caso.sintoma_covid_secrecion_nasal = params[:sintoma_covid_secrecion_nasal] == "1"
    @caso.sintoma_covid_malestar_general = params[:sintoma_covid_malestar_general] == "1"
    @caso.sintoma_covid_dolor_muscular = params[:sintoma_covid_dolor_muscular] == "1"
    @caso.sintoma_covid_diarrea = params[:sintoma_covid_diarrea] == "1"
    @caso.sintoma_covid_dolor_abdominal = params[:sintoma_covid_dolor_abdominal] == "1"
    @caso.sintoma_covid_dolor_toraxico = params[:sintoma_covid_dolor_toraxico] == "1"
    @caso.sintoma_covid_vomito = params[:sintoma_covid_vomito] == "1"
    @caso.relacionamiento_con_infectados = params[:relacionamiento_con_infectados] == "1"
    @caso.ha_estado_fuera_del_pais = params[:ha_estado_fuera_del_pais] == "1"
    @caso.es_trabajador_de_salud = params[:es_trabajador_de_salud] == "1"
    @caso.fallecido = params[:fallecido] == "1"

    @caso.ciudad_uno = params[:ciudad_uno]
    @caso.ciudad_dos = params[:ciudad_dos]
    @caso.fecha_ingreso_uno = params[:fecha_ingreso_uno]
    @caso.fecha_ingreso_dos = params[:fecha_ingreso_dos]
    @caso.fecha_salida_uno = params[:fecha_salida_uno]
    @caso.fecha_salida_dos = params[:fecha_salida_dos]
    @caso.conglomerado = params[:conglomerado]
    @caso.sin_datos = false

    @caso.save!
    @caso.calculate_triage
  end

  def update_iec
    if params[:contenido_desplazamiento].delete(" ") != "" && (params[:fecha_desplazamiento].nil? || params[:fecha_desplazamiento].empty?)
      @error = "Debes especificar fecha del desplazamiento"
      return
    end
    if (!params[:fecha_desplazamiento].nil? && !params[:fecha_desplazamiento].empty?) && (params[:contenido_desplazamiento].nil? || params[:contenido_desplazamiento].empty?)
      @error = "Debes especificar la observacion del desplazamiento"
      return
    end

    if params[:institucion_consulta].delete(" ") != "" && (params[:fecha_consulta].nil? || params[:fecha_consulta].empty?)
      @error = "Debes especificar fecha de consulta"
      return
    end
    if (!params[:fecha_consulta].nil? && !params[:fecha_consulta].empty?) && (params[:institucion_consulta].nil? || params[:institucion_consulta].empty?)
      @error = "Debes especificar la observacion del desplazamiento"
      return
    end
    @caso = CasoSaludPublica.find_by_id params[:id]
    repeated_caso = CasoSaludPublica.find_by_tipo_documento_and_numero_documento_and_municipio_id(params[:tipo_documento], params[:numero_documento], current_municipio.id)
    if repeated_caso && repeated_caso.id != @caso.id
      @error = "Ya existe un registro con el numero de documento dado"
      return
    end
    @caso.primer_nombre = params[:primer_nombre]
    @caso.primer_apellido = params[:primer_apellido]
    @caso.segundo_nombre = params[:segundo_nombre]
    @caso.segundo_apellido = params[:segundo_apellido]
    @caso.fecha_nacimiento = params[:fecha_nacimiento]
    @caso.edad = params[:edad]
    @caso.unidad_medida = params[:unidad_medida]
    @caso.email = params[:email]
    @caso.regimen = params[:regimen]
    @caso.tipo_documento = params[:tipo_documento]
    @caso.numero_documento = params[:numero_documento].strip
    @caso.sexo = params[:sexo]
    @caso.tipo_sanguineo = params[:tipo_sanguineo]
    @caso.entidad_prestadora = EntidadPrestadora.find_by_id(params[:entidad_prestadora_id])
    @caso.institucion = Institucion.find_by_id(params[:institucion_id])
    @caso.country = Country.find_by_id(params[:country_id])

    @caso.departamento = current_municipio.departamento
    @caso.municipio = current_municipio

    @caso.departamento_origen = Departamento.find_by_id(params[:departamento_id])
    @caso.municipio_origen = Municipio.find_by_id(params[:municipio_id])

    @caso.barrio = Barrio.find_by_id(params[:barrio_id])
    @caso.direccion = params[:direccion]
    @caso.telefono = params[:telefono]
    @caso.observacion = params[:observacion].tr("\n", "").tr("\r", "").tr(";", ",")
    @caso.country_uno = Country.find_by_id(params[:country_uno_id])
    @caso.country_dos = Country.find_by_id(params[:country_dos_id])
    @caso.primer_nombre_contacto_uno = params[:primer_nombre_contacto_uno]
    @caso.primer_apellido_contacto_uno = params[:primer_apellido_contacto_uno]
    @caso.segundo_nombre_contacto_uno = params[:segundo_nombre_contacto_uno]
    @caso.segundo_apellido_contacto_uno = params[:segundo_apellido_contacto_uno]
    @caso.country_contacto_uno = Country.find_by_id(params[:country_id_contacto_uno])
    @caso.departamento_contacto_uno = Departamento.find_by_id(params[:departamento_id_contacto_uno])
    @caso.municipio_contacto_uno = Municipio.find_by_id(params[:municipio_id_contacto_uno])
    @caso.direccion_contacto_uno = params[:direccion_contacto_uno]
    @caso.telefono_contacto_uno = params[:telefono_contacto_uno]
    @caso.diagnostico_principal = Diagnostico.find_by_id("25168")
    @caso.codigo_evento = params[:codigo_evento]
    @caso.servicio = params[:servicio]
    @caso.tipo_contagio = params[:tipo_contagio]

    @caso.sintoma_covid_fiebre = params[:sintoma_covid_fiebre] == "1"
    @caso.sintoma_covid_tos = params[:sintoma_covid_tos] == "1"
    @caso.sintoma_covid_dificultad_respiratoria = params[:sintoma_covid_dificultad_respiratoria] == "1"
    @caso.sintoma_covid_secrecion_nasal = params[:sintoma_covid_secrecion_nasal] == "1"
    @caso.sintoma_covid_malestar_general = params[:sintoma_covid_malestar_general] == "1"
    @caso.sintoma_covid_dolor_muscular = params[:sintoma_covid_dolor_muscular] == "1"
    @caso.sintoma_covid_diarrea = params[:sintoma_covid_diarrea] == "1"
    @caso.sintoma_covid_dolor_abdominal = params[:sintoma_covid_dolor_abdominal] == "1"
    @caso.sintoma_covid_dolor_toraxico = params[:sintoma_covid_dolor_toraxico] == "1"
    @caso.sintoma_covid_vomito = params[:sintoma_covid_vomito] == "1"
    @caso.relacionamiento_con_infectados = params[:relacionamiento_con_infectados] == "1"
    @caso.ha_estado_fuera_del_pais = params[:ha_estado_fuera_del_pais] == "1"
    @caso.es_trabajador_de_salud = params[:es_trabajador_de_salud] == "1"
    @caso.fallecido = params[:fallecido] == "1"

    @caso.ciudad_uno = params[:ciudad_uno]
    @caso.ciudad_dos = params[:ciudad_dos]
    @caso.fecha_ingreso_uno = params[:fecha_ingreso_uno]
    @caso.fecha_ingreso_dos = params[:fecha_ingreso_dos]
    @caso.fecha_salida_uno = params[:fecha_salida_uno]
    @caso.fecha_salida_dos = params[:fecha_salida_dos]
    @caso.conglomerado = params[:conglomerado]

    @caso.fecha_investigacion = params[:fecha_investigacion]
    @caso.zona_residencia = params[:zona_residencia]
    @caso.ocupacion = params[:ocupacion]
    @caso.fecha_inicio_sintomas = params[:fecha_inicio_sintomas]
    @caso.lugar_contacto = params[:lugar_contacto]
    @caso.sintoma_covid_taquipnea = params[:sintoma_covid_taquipnea] == "1"
    @caso.sintoma_covid_dolor_garganta = params[:sintoma_covid_dolor_garganta] == "1"
    @caso.sintoma_escalofrios = params[:sintoma_escalofrios] == "1"
    @caso.sintoma_nauseas = params[:sintoma_nauseas] == "1"
    @caso.sintoma_mialgia = params[:sintoma_mialgia] == "1"
    @caso.sintoma_dolor_cabeza = params[:sintoma_dolor_cabeza] == "1"
    @caso.sintoma_asma = params[:sintoma_asma] == "1"
    @caso.sintoma_enfermedad_pulmonar_cronica = params[:sintoma_enfermedad_pulmonar_cronica] == "1"
    @caso.sintoma_trastorno_neurologico_cronico = params[:sintoma_trastorno_neurologico_cronico] == "1"
    @caso.sintoma_inmunosupresion = params[:sintoma_inmunosupresion] == "1"
    @caso.sintoma_enfermedad_renal_cronica = params[:sintoma_enfermedad_renal_cronica] == "1"
    @caso.sintoma_enfermedad_cardiaca = params[:sintoma_enfermedad_cardiaca] == "1"
    @caso.sintoma_enfermedad_hematologica_cronica = params[:sintoma_enfermedad_hematologica_cronica] == "1"
    @caso.sintoma_diabetes = params[:sintoma_diabetes] == "1"
    @caso.sintoma_obesidad = params[:sintoma_obesidad] == "1"
    @caso.sintoma_enfermedad_hepatica_cronica = params[:sintoma_enfermedad_hepatica_cronica] == "1"
    @caso.sintoma_embarazo = params[:sintoma_embarazo] == "1"
    @caso.semanas_gestacion = params[:semanas_gestacion]
    @caso.sintoma_tabaquismo = params[:sintoma_tabaquismo] == "1"
    @caso.sintoma_alcoholismo = params[:sintoma_alcoholismo] == "1"
    @caso.sintoma_transtorno_reumatologico = params[:sintoma_transtorno_reumatologico] == "1"

    if @caso.responsable_investigacion.nil?
      @caso.responsable_investigacion = current_usuario
      @caso.fecha_actualizacion_iec = Time.now
    end

    @caso.asintomatico = params[:asintomatico] == "1"
    @caso.otra_patologia = params[:otra_patologia]

    if !params[:contenido_desplazamiento].nil? && !params[:contenido_desplazamiento].empty? && !params[:fecha_desplazamiento].nil? && !params[:fecha_desplazamiento].empty?
      @desplazamiento = Desplazamiento.create!(contenido: params[:contenido_desplazamiento], fecha: params[:fecha_desplazamiento])
      @desplazamiento.caso_salud_publica = @caso
      @desplazamiento.usuario = current_usuario
      @desplazamiento.save!
    end
    if !params[:institucion_consulta].nil? && !params[:institucion_consulta].empty? && !params[:fecha_consulta].nil? && !params[:fecha_consulta].empty?
      @consulta = Consulta.create!(institucion: params[:institucion_consulta], fecha: params[:fecha_consulta])
      @consulta.caso_salud_publica = @caso
      @consulta.usuario = current_usuario
      @consulta.save!
    end
    @caso.save!
    @caso.calculate_triage
    @reload_modal = params[:extra_button_one] || params[:extra_button_two]
  end

  def edit_crue
    @caso = CasoSaludPublica.find_by_id params[:id]
    @departamentos = Departamento.all.order("nombre ASC")
    @municipios = @caso.departamento_origen.nil? ? [] : @caso.departamento_origen.municipios.order("nombre ASC")
  end

  def update_crue
    @caso = CasoSaludPublica.find_by_id params[:id]
    @caso.servicio_crue = params[:servicio]
    @caso.fallecido = params[:fallecido] == "1"
    @caso.fecha_defuncion = params[:fecha_defuncion]
    @caso.tiene_ventilador = params[:tiene_ventilador] == "1"
    @caso.estado_seguimiento_crue = params[:estado]
    @caso.direccion = params[:direccion]
    @caso.departamento_origen = Departamento.find_by_id(params[:departamento_id])
    @caso.municipio_origen = Municipio.find_by_id(params[:municipio_id])
    @caso.numero_oficial = params[:numero_oficial]
    @caso.save!
    if params[:contenido] && params[:contenido].delete(" ") != ""
      @seguimiento = SeguimientoCaso.create!(crue: true, contenido: params[:contenido])
      @seguimiento.usuario = current_usuario
      @seguimiento.caso_salud_publica = @caso
      @seguimiento.save!
    end
  end

  def search
    where = ""
    where_lines = []
    where_lines << "(caso.created_at between ('#{Date.strptime(params[:start_date], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date].nil? && !params[:start_date].empty? && !params[:end_date].nil? && !params[:end_date].empty?
    where_lines << "(caso.fecha_investigacion between ('#{Date.strptime(params[:start_date_investigacion], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date_investigacion], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date_investigacion].nil? && !params[:start_date_investigacion].empty? && !params[:end_date_investigacion].nil? && !params[:end_date_investigacion].empty?
    where_lines << "(caso.fecha_actualizacion_iec between ('#{Date.strptime(params[:start_date_iec], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date_iec], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date_iec].nil? && !params[:start_date_iec].empty? && !params[:end_date_iec].nil? && !params[:end_date_iec].empty?
    where_lines << "(caso.numero_oficial = #{params[:numero_oficial]})" if params[:numero_oficial] && params[:numero_oficial] != ""
    where_lines << "(caso.id = #{params[:id]})" if params[:id] && params[:id] != ""
    where_lines << "(caso.numero_documento ILIKE '%#{params[:numero_documento].strip}%')" if params[:numero_documento] && params[:numero_documento] != ""
    where_lines << "(caso.institucion_id = #{params[:institucion_id]})" if params[:institucion_id] && params[:institucion_id] != ""
    where_lines << "(caso.municipio_id = #{current_municipio.id})" if current_usuario.municipio
    where_lines << "(caso.municipio_origen_id = '#{current_municipio.id}')" if current_usuario.municipio_alterno
    where_lines << "(caso.servicio = #{params[:servicio]})" if params[:servicio] && params[:servicio] != ""
    where_lines << "(caso.entidad_prestadora_id = #{params[:entidad_prestadora_id]})" if params[:entidad_prestadora_id] && params[:entidad_prestadora_id] != ""
    where_lines << "(caso.country_id = #{params[:country_id]})" if params[:country_id] && params[:country_id] != ""
    where_lines << "(caso.usuario_id = #{params[:usuario_id]})" if params[:usuario_id] && params[:usuario_id] != ""
    where_lines << "(caso.sexo = #{params[:sexo]})" if params[:sexo] && params[:sexo] != ""
    where_lines << "(caso.origen = #{params[:origen]})" if params[:origen] && params[:origen] != ""
    where_lines << "(caso.estado = #{params[:estado]})" if params[:estado] && params[:estado] != ""
    where_lines << "(caso.estado_enfermedad = #{params[:estado_enfermedad]})" if params[:estado_enfermedad] && params[:estado_enfermedad] != ""
    where_lines << "(caso.publico = TRUE)" if params[:estado_enfermedad] == "2"
    where_lines << "(caso.reinfeccion = TRUE)" if params[:estado_enfermedad] == "5"
    where_lines << "(caso.estado_seguimiento = #{params[:estado_seguimiento]})" if params[:estado_seguimiento] && params[:estado_seguimiento] != ""
    where_lines << "(caso.triage = #{params[:triage]})" if params[:triage] && params[:triage] != ""
    where_lines << "(caso.tipo_contagio = #{params[:tipo_contagio]})" if params[:tipo_contagio] && params[:tipo_contagio] != ""
    where_lines << "(caso.responsable_investigacion_id IS NULL)" if params[:estado_iec] && params[:estado_iec] == "2"
    where_lines << "(caso.responsable_investigacion_id IS NOT NULL)" if params[:estado_iec] && params[:estado_iec] == "1"
    where_lines << "(caso.primer_nombre ILIKE '%#{params[:primer_nombre]}%')" if !params[:primer_nombre].nil? && !params[:primer_nombre].empty?
    where_lines << "(caso.primer_apellido ILIKE '%#{params[:primer_apellido]}%')" if !params[:primer_apellido].nil? && !params[:primer_apellido].empty?

    where = where_lines.join(" AND ")
    select = <<-FOO
      CASE
        WHEN caso.triage = 1 THEN 'table-success'
        WHEN caso.triage = 2 THEN 'table-warning'
        WHEN caso.triage = 3 THEN 'table-danger'
        ELSE ''
      END AS caso_table_value,
      caso.numero_oficial AS caso_numero_oficial,
      caso.id AS caso_id,
      concat(caso.primer_nombre, ' ', caso.primer_apellido, ' ', caso.segundo_nombre, ' ', caso.segundo_apellido) AS caso_nombre_completo,
      (caso.nivel + 1) AS caso_nivel,
      '-' AS caso_cantidad_contactos,
      '-' AS caso_cantidad_muestras,
      DATE(caso.fecha_investigacion) AS caso_fecha_investigacion,
      DATE(caso.fecha_actualizacion_iec) AS caso_fecha_actualizacion_iec,
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
      CASE
        WHEN caso.sexo = 1 THEN 'M'
        WHEN caso.sexo = 2 THEN 'F'
        ELSE ''
      END AS caso_sexo_value,
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
      CASE
        WHEN caso.servicio_crue = 1 THEN 'GENERAL PEDÍATRICA'
        WHEN caso.servicio_crue = 2 THEN 'GENERAR ADULTOS'
        WHEN caso.servicio_crue = 3 THEN 'UCI 1/2 ADULTOS'
        WHEN caso.servicio_crue = 4 THEN 'UCI 1/2 NEONATAL'
        WHEN caso.servicio_crue = 5 THEN 'UCI 1/2 PEDIÁTRICO'
        WHEN caso.servicio_crue = 6 THEN 'UCI ADULTOS'
        WHEN caso.servicio_crue = 7 THEN 'UCI NEONATAL'
        WHEN caso.servicio_crue = 8 THEN 'UCI PEDIÁTRICO'
        WHEN caso.servicio_crue = 9 THEN 'EN CASA'
        WHEN caso.servicio_crue = 10 THEN 'FALLECIDO'
        ELSE ''
      END AS caso_servicio_crue_value,
      CASE
        WHEN usuario.entidad_prestadora_id IS NOT NULL THEN entidad_prestadora_usuario.nombre
        WHEN caso.institucion_id IS NOT NULL THEN institucion.nombre
        WHEN usuario.institucion_id IS NOT NULL THEN institucion_usuario.nombre
        WHEN usuario.laboratorio_id IS NOT NULL THEN laboratorio.nombre
        ELSE 'SEC SALUD'
      END AS caso_origen_value,
      concat(usuario.primer_nombre, ' ', usuario.primer_apellido, ' ', usuario.segundo_nombre, ' ', usuario.segundo_apellido) AS usuario_nombre_completo,
      CASE
        WHEN caso.estado = 1 THEN 'VIGENTE'
        WHEN caso.estado = 1 THEN 'CERRADO'
        ELSE ''
      END AS caso_estado_value,
      CASE
        WHEN caso.estado_seguimiento = 1 THEN 'EN SEGUIMIENTO'
        WHEN caso.estado_seguimiento = 2 THEN 'REQUIERE HOSPITALIZACION'
        WHEN caso.estado_seguimiento = 3 THEN 'RESUELTO SATISFACTORIAMENTE'
        WHEN caso.estado_seguimiento = 4 THEN 'NO CUMPLE CON DEFINICION DE CASO'
        WHEN caso.estado_seguimiento = 5 THEN 'AISLAMIENTO EN CASA'
        WHEN caso.estado_seguimiento = 6 THEN 'INTERNACION'
        WHEN caso.estado_seguimiento = 7 THEN 'FALLECIDO'
        WHEN caso.estado_seguimiento = 8 THEN 'OBSERVACION'
        WHEN caso.estado_seguimiento = 9 THEN 'SEGUIMIENTO FINALIZADO'
        ELSE 'SEC SALUD'
      END AS caso_estado_seguimiento_value,
      CASE
        WHEN caso.fallecido = TRUE THEN 'FALLECIDO'
        ELSE 'VIVO'
      END AS caso_fallecido_value,
      CASE
        WHEN caso.responsable_investigacion_id IS NOT NULL THEN 'REALIZADO'
        ELSE 'PENDIENTE'
      END AS caso_iec_realizado_value,
      caso.id AS caso_id,
      caso.estado AS caso_estado
    FOO

    query = <<-FOO
      SELECT
      #{select}
      FROM caso_salud_publicas AS caso
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      LEFT JOIN institucions AS institucion
      ON caso.institucion_id = institucion.id
      LEFT JOIN usuarios AS usuario
      ON caso.usuario_id = usuario.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora_usuario
      ON usuario.entidad_prestadora_id = entidad_prestadora_usuario.id
      LEFT JOIN institucions AS institucion_usuario
      ON usuario.institucion_id = institucion_usuario.id
      LEFT JOIN laboratorios AS laboratorio
      ON caso.laboratorio_id = laboratorio.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
      ORDER BY caso.created_at DESC
    FOO

    query_paged = <<-FOO
      #{query}
      LIMIT #{params[:size]}
      OFFSET #{params[:index].to_i - 1}
    FOO
    query_counter = <<-FOO
      SELECT COUNT(*)
      FROM caso_salud_publicas AS caso
      LEFT JOIN entidad_prestadoras AS entidad_prestadora
      ON caso.entidad_prestadora_id = entidad_prestadora.id
      LEFT JOIN institucions AS institucion
      ON caso.institucion_id = institucion.id
      LEFT JOIN usuarios AS usuario
      ON caso.usuario_id = usuario.id
      LEFT JOIN entidad_prestadoras AS entidad_prestadora_usuario
      ON usuario.entidad_prestadora_id = entidad_prestadora_usuario.id
      LEFT JOIN institucions AS institucion_usuario
      ON usuario.institucion_id = institucion_usuario.id
      LEFT JOIN laboratorios AS laboratorio
      ON caso.laboratorio_id = laboratorio.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    @registros = ActiveRecord::Base.connection.execute(query_paged)
    @cantidad = ActiveRecord::Base.connection.execute(query_counter)
    @cantidad_registros = @cantidad[0]["count"]
    @cantidad_paginas = (@cantidad_registros / params[:size].to_i).ceil
    render layout: false
  end

  def destroy
    caso = CasoSaludPublica.find_by_id params[:id]
    caso.seguimiento_casos.each do |seguimiento|
      seguimiento.destroy!
    end
    caso.muestras.each do |muestra|
      muestra.destroy!
    end
    caso.destroy!
  end

  def edit_ubicacion
    @close = params[:close] == "true"
    @caso = CasoSaludPublica.find_by_id params[:id]
    render layout: false
  end

  def update_ubicacion
    @caso = CasoSaludPublica.find_by_id params[:id]
    @caso.barrio = params[:barrio]
    @caso.direccion = params[:direccion]
    @caso.referencia = params[:referencia]
    @caso.latitude = params[:latitude]
    @caso.longitude = params[:longitude]
    @caso.save!
  end

  def pdf_iec
    @caso = CasoSaludPublica.find_by_id params[:id]
    @llamada = Llamada.find_by_id params[:llamada_id]
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
    @instituciones = Institucion.where(activo: true, municipio: current_municipio).order("nombre ASC")
    @countries = Country.all.order("nombre ASC")
    @departamentos = Departamento.all.order("nombre ASC")
    @colombia = Country.find_by_codigo("co")
    @municipios = @caso.departamento_origen.nil? ? [] : @caso.departamento_origen.municipios.order("nombre ASC")
    @barrios = @caso.municipio_origen.nil? ? [] : @caso.municipio_origen.barrios.order("nombre ASC")
    @municipios_contacto_uno = @caso.departamento_contacto_uno.nil? ? [] : @caso.departamento_contacto_uno.municipios.order("nombre ASC")
    #render layout:false
  end

  def cerrar
    @caso = CasoSaludPublica.find_by_id params[:id]
    render layout: false
  end

  def do_cerrar
    @caso = CasoSaludPublica.find_by_id params[:id]
    @caso.estado = ESTADO_SP_CERRADO
    @caso.usuario_cierre = current_usuario
    @caso.save!
  end

  def existe
    caso = CasoSaludPublica.find_by_tipo_documento_and_numero_documento_and_municipio_id(params[:tipo_documento], params[:numero_documento], current_municipio.id)
    render json: { result: !caso.nil? }.to_json
  end

  def owned
    Pusher.trigger("caso_#{params[:id]}", "owned", id: current_usuario.id, nombre: current_usuario.nombre_completo)
    render json: { result: "OK" }.to_json
  end

  def dashboard
    @casos_totales = CasoSaludPublica.where(municipio: current_municipio).count
    @casos_negativos = CasoSaludPublica.where(municipio: current_municipio, estado_enfermedad: 3).count
    @casos_positivos = CasoSaludPublica.where(municipio: current_municipio, estado_enfermedad: 2, publico: true).count
    @casos_por_confirmar = CasoSaludPublica.where(municipio: current_municipio, estado_enfermedad: 1).count

    hash_caso = {}
    hash_caso["caso_salud_publicas.municipio_id"] = current_municipio.id
    @muestras_totales = Muestra.where({}).includes([:caso_salud_publica]).where(hash_caso).count
    @muestras_hoy = Muestra.where(created_at: Time.now.beginning_of_day..Time.now.end_of_day).includes([:caso_salud_publica]).where(hash_caso).count

    @llamadas_totales = Llamada.where(municipio: current_municipio).count
    @llamadas_hoy = Llamada.where(municipio: current_municipio, created_at: Time.now.beginning_of_day..Time.now.end_of_day).count
    @cantidad_laboratorios = Laboratorio.where(municipio: current_municipio).count
    @cantidad_ips = Institucion.where(municipio: current_municipio).count
    @cantidad_eps = EntidadPrestadora.count

    @registros_positivos = CasoSaludPublica.where(municipio: current_municipio, estado_enfermedad: 2, publico: true).where.not(latitude: nil, longitude: nil).to_json(only: %i[id edad numero_documento telefono direccion latitude longitude], methods: [:nombre_completo, :edad_value])
    @registros_negativos = CasoSaludPublica.where(municipio: current_municipio, estado_enfermedad: 3).where.not(latitude: nil, longitude: nil).to_json(only: %i[id edad numero_documento telefono direccion latitude longitude], methods: [:nombre_completo, :edad_value])
    @registros_por_confirmar = CasoSaludPublica.where(municipio: current_municipio, estado_enfermedad: 1).where.not(latitude: nil, longitude: nil).to_json(only: %i[id edad numero_documento telefono direccion latitude longitude], methods: [:nombre_completo, :edad_value])

    @response = HTTParty.get("https://sem-barranquilla-api.herokuapp.com/ambulancia/recursos",
                             {
      body: {},
      headers: {
        'Content-Type': "application/json",
        'Authentication': "sqMq#RR^7HZEM^T%DbpFGhzP^f*SQUlmMIGdeRCy**3m1FVTKb",
      },
    })
    @response = @response.parsed_response["data"]
  end

  def dashboard_v2
    @response = HTTParty.get("https://sem-barranquilla-api.herokuapp.com/ambulancia/recursos",
                             {
      body: {},
      headers: {
        'Content-Type': "application/json",
        'Authentication': "sqMq#RR^7HZEM^T%DbpFGhzP^f*SQUlmMIGdeRCy**3m1FVTKb",
      },
    })
    @response = @response.parsed_response["data"]
  end

  def dashboard_v3
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @laboratorios = Laboratorio.where(municipio: current_municipio, coordinacion: [false, nil]).order("nombre ASC")
    @laboratorios_cordinacion = Laboratorio.where(municipio: current_municipio, coordinacion: true).order("nombre ASC")

    start_date = DateTime.parse(@start_date)
    end_date = DateTime.parse(@end_date)
    #fecha_actualizacion_estado_enfermedad y fecha_actualizacion_servicio
    @casos_negativos = CasoSaludPublica.where(municipio: current_municipio, estado_enfermedad: 3).count
    @casos_positivos = CasoSaludPublica.where(municipio: current_municipio, estado_enfermedad: 2, publico: true).count
    @casos_recuperados = CasoSaludPublica.where(municipio: current_municipio, estado_enfermedad: 4).count
    @casos_por_confirmar = CasoSaludPublica.where(municipio: current_municipio, estado_enfermedad: 1).count

    @casos_por_servicio = [
      { id: 1, nombre: "HOSPITALIZACION", count: 0 },
      { id: 2, nombre: "URGENCIA", count: 0 },
      { id: 3, nombre: "UCI PLENA", count: 0 },
      { id: 4, nombre: "UCI INTERMEDIA", count: 0 },
      { id: 0, nombre: "NO TIENE", count: 0 },
      { id: 5, nombre: "AMBULATORIO", count: 0 },
    ]

    @casos_por_servicio.each do |item|
      item[:count] = CasoSaludPublica.where(municipio: current_municipio, servicio: item[:id]).count
    end

    @usuarios = []
    @laboratorios_cordinacion.each do |lab|
      @usuarios.push(*lab.usuarios)
    end
  end

  def dashboard_v4
    data = []
    registros_positivos = CasoSaludPublica.where(municipio: Municipio.find(4), estado_enfermedad: 2, publico: true)
    registros_positivos.each do |registro|
      data << [registro.longitude, registro.latitude]
    end
    kmeans_positivos = KMeansClusterer.run 40, data
    @result = []
    kmeans_positivos.clusters.each do |cluster|
      @result << { lat: cluster.centroid[1], lng: cluster.centroid[0], count: cluster.points.count }
    end
  end

  def dashboard_v5
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    start_date = DateTime.parse(@start_date)
    end_date = DateTime.parse(@end_date)
    @usuarios = current_municipio.usuarios.order("primer_nombre ASC")
    @usuarios_v2 = []
    @usuarios.each do |usuario|
      count = CasoSaludPublica.where(responsable_investigacion: usuario, fecha_actualizacion_iec: start_date.beginning_of_day..end_date.end_of_day).count
      @usuarios_v2 << { usuario: usuario, count: count } if count > 0
    end
  end

  def agregar_contacto
    @parent = CasoSaludPublica.find_by_id params[:id]
    @caso = CasoSaludPublica.find_by_id params[:son_id]
    render layout: false
  end

  def do_agregar_contacto
    @parent = CasoSaludPublica.find_by_id params[:id]
    @caso = CasoSaludPublica.find_by_id params[:son_id]

    @contacto = Contacto.create! parentezco: params[:parentezco], tipo_contacto: params[:tipo_contacto]
    @contacto.parent = @parent
    @contacto.son = @caso
    @contacto.save!
  end

  def download
    where = ""
    where_lines = []
    if params[:normal]
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
      where_lines << "(caso_salud_publicas.created_at between ('#{Date.strptime(params[:start_date], "%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Date.strptime(params[:end_date], "%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')" if !params[:start_date].nil? && !params[:start_date].empty? && !params[:end_date].nil? && !params[:end_date].empty?
      where_lines << "(muestras.fecha_recepcion_interna between ('#{Date.strptime(params[:start_date_recibido], "%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Date.strptime(params[:end_date_recibido], "%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')" if !params[:start_date_recibido].nil? && !params[:start_date_recibido].empty? && !params[:end_date_recibido].nil? && !params[:end_date_recibido].empty?
      where_lines << "(muestras.fecha_despacho_interna between ('#{Date.strptime(params[:start_date_enviado], "%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Date.strptime(params[:end_date_enviado], "%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')" if !params[:start_date_enviado].nil? && !params[:start_date_enviado].empty? && !params[:end_date_enviado].nil? && !params[:end_date_enviado].empty?
      where_lines << "(caso_salud_publicas.fecha_investigacion between ('#{Date.strptime(params[:start_date_investigacion], "%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Date.strptime(params[:end_date_investigacion], "%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')" if !params[:start_date_investigacion].nil? && !params[:start_date_investigacion].empty? && !params[:end_date_investigacion].nil? && !params[:end_date_investigacion].empty?
      where_lines << "(caso_salud_publicas.fecha_actualizacion_iec between ('#{Date.strptime(params[:start_date_iec], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date_iec], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date_iec].nil? && !params[:start_date_iec].empty? && !params[:end_date_iec].nil? && !params[:end_date_iec].empty?
      where_lines << "(caso_salud_publicas.responsable_investigacion_id IS NULL)" if params[:estado_iec] && params[:estado_iec] == "2"
      where_lines << "(caso_salud_publicas.responsable_investigacion_id IS NOT NULL)" if params[:estado_iec] && params[:estado_iec] == "1"
    elsif params[:without_restriction]
      where_lines << "(caso_salud_publicas.id = #{params[:id]})" if !params[:id].nil? && !params[:id].empty?
      where_lines << "(caso_salud_publicas.numero_documento = '#{params[:numero_documento_search]}')" if !params[:numero_documento_search].nil? && !params[:numero_documento_search].empty?
      where_lines << "(caso_salud_publicas.municipio_id = #{current_municipio.id})"
      where_lines << "(caso_salud_publicas.entidad_prestadora_id = #{params[:entidad_prestadora_id]})" if !params[:entidad_prestadora_id].nil? && !params[:entidad_prestadora_id].empty?
      where_lines << "(caso_salud_publicas.sexo = #{params[:sexo]})" if !params[:sexo].nil? && !params[:sexo].empty?
      where_lines << "(caso_salud_publicas.servicio = #{params[:servicio]})" if !params[:servicio].nil? && !params[:servicio].empty?
      where_lines << "(caso_salud_publicas.institucion_id = #{params[:institucion_id]})" if !params[:institucion_id].nil? && !params[:institucion_id].empty?
      where_lines << "(caso_salud_publicas.estado_enfermedad = #{params[:resultado]})" if !params[:resultado].nil? && !params[:resultado].empty?
      where_lines << "(caso_salud_publicas.publico = TRUE)" if params[:resultado] == "2"
      where_lines << "(caso_salud_publicas.created_at between ('#{Date.strptime(params[:start_date], "%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Date.strptime(params[:end_date], "%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')" if !params[:start_date].nil? && !params[:start_date].empty? && !params[:end_date].nil? && !params[:end_date].empty?
      where_lines << "(caso_salud_publicas.fecha_investigacion between ('#{Date.strptime(params[:start_date_investigacion], "%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Date.strptime(params[:end_date_investigacion], "%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')" if !params[:start_date_investigacion].nil? && !params[:start_date_investigacion].empty? && !params[:end_date_investigacion].nil? && !params[:end_date_investigacion].empty?
      where_lines << "(caso_salud_publicas.fecha_actualizacion_iec between ('#{Date.strptime(params[:start_date_iec], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date_iec], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date_iec].nil? && !params[:start_date_iec].empty? && !params[:end_date_iec].nil? && !params[:end_date_iec].empty?
      where_lines << "(caso_salud_publicas.responsable_investigacion_id IS NULL)" if params[:estado_iec] && params[:estado_iec] == "2"
      where_lines << "(caso_salud_publicas.responsable_investigacion_id IS NOT NULL)" if params[:estado_iec] && params[:estado_iec] == "1"
    elsif params[:contactos]
      where_lines << "(caso_salud_publicas.id = #{params[:id]})" if !params[:id].nil? && !params[:id].empty?
      where_lines << "(caso_salud_publicas.numero_documento = '#{params[:numero_documento_search]}')" if !params[:numero_documento_search].nil? && !params[:numero_documento_search].empty?
      where_lines << "(caso_salud_publicas.municipio_id = #{current_municipio.id})"
      where_lines << "(caso_salud_publicas.entidad_prestadora_id = #{params[:entidad_prestadora_id]})" if !params[:entidad_prestadora_id].nil? && !params[:entidad_prestadora_id].empty?
      where_lines << "(caso_salud_publicas.sexo = #{params[:sexo]})" if !params[:sexo].nil? && !params[:sexo].empty?
      where_lines << "(caso_salud_publicas.servicio = #{params[:servicio]})" if !params[:servicio].nil? && !params[:servicio].empty?
      where_lines << "(caso_salud_publicas.institucion_id = #{params[:institucion_id]})" if !params[:institucion_id].nil? && !params[:institucion_id].empty?
      where_lines << "(caso_salud_publicas.estado_enfermedad = #{params[:resultado]})" if !params[:resultado].nil? && !params[:resultado].empty?
      where_lines << "(caso_salud_publicas.publico = TRUE)" if params[:resultado] == "2"
      where_lines << "(caso_salud_publicas.created_at between ('#{Date.strptime(params[:start_date], "%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Date.strptime(params[:end_date], "%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')" if !params[:start_date].nil? && !params[:start_date].empty? && !params[:end_date].nil? && !params[:end_date].empty?
      where_lines << "(caso_salud_publicas.fecha_investigacion between ('#{Date.strptime(params[:start_date_investigacion], "%Y-%m-%d")} 00:00:00'::timestamp without time zone at time zone 'America/Los_Angeles') and ('#{Date.strptime(params[:end_date_investigacion], "%Y-%m-%d")} 23:59:00')::timestamp without time zone at time zone 'America/Los_Angeles')" if !params[:start_date_investigacion].nil? && !params[:start_date_investigacion].empty? && !params[:end_date_investigacion].nil? && !params[:end_date_investigacion].empty?
      where_lines << "(caso_salud_publicas.fecha_actualizacion_iec between ('#{Date.strptime(params[:start_date_iec], "%Y-%m-%d")} 05:00:00') and ('#{Date.strptime(params[:end_date_iec], "%Y-%m-%d") + 1.days} 04:59:59.999999'))" if !params[:start_date_iec].nil? && !params[:start_date_iec].empty? && !params[:end_date_iec].nil? && !params[:end_date_iec].empty?
      where_lines << "(caso_salud_publicas.responsable_investigacion_id IS NULL)" if params[:estado_iec] && params[:estado_iec] == "2"
      where_lines << "(caso_salud_publicas.responsable_investigacion_id IS NOT NULL)" if params[:estado_iec] && params[:estado_iec] == "1"
    end

    where = where_lines.join(" AND ")
    if params[:contactos]
      query = <<-FOO
        SELECT
        #{QUERY_CONTACTOS}
        FROM contactos
        LEFT JOIN caso_salud_publicas
        ON caso_salud_publicas.id = contactos.son_id
        LEFT JOIN caso_salud_publicas as parent
        ON parent.id = contactos.parent_id
        LEFT JOIN muestras
        ON muestras.caso_salud_publica_id = caso_salud_publicas.id
        LEFT JOIN institucions
        ON muestras.institucion_id = institucions.id
        LEFT JOIN entidad_prestadoras
        ON caso_salud_publicas.entidad_prestadora_id = entidad_prestadoras.id
        LEFT JOIN municipios as municipio_origen
        ON caso_salud_publicas.municipio_id = municipio_origen.id
        LEFT JOIN departamentos as departamento_origen
        ON caso_salud_publicas.departamento_id = departamento_origen.id
        LEFT JOIN countries
        ON caso_salud_publicas.country_id = countries.id
        LEFT JOIN barrios
        ON caso_salud_publicas.barrio_id = barrios.id
        LEFT JOIN countries as country_uno
        ON caso_salud_publicas.country_uno_id = country_uno.id
        LEFT JOIN countries as country_dos
        ON caso_salud_publicas.country_dos_id = country_dos.id
        LEFT JOIN countries as country_contacto_uno
        ON caso_salud_publicas.country_id_contacto_uno = country_contacto_uno.id
        LEFT JOIN departamentos as departamento_contacto_uno
        ON caso_salud_publicas.departamento_id_contacto_uno = departamento_contacto_uno.id
        LEFT JOIN municipios as municipio_contacto_uno
        ON caso_salud_publicas.municipio_id_contacto_uno = municipio_contacto_uno.id
        LEFT JOIN usuarios as responsable_investigacion
        ON caso_salud_publicas.responsable_investigacion_id = responsable_investigacion.id
        WHERE #{where.empty? || where == " " ? "TRUE" : where}
      FOO
    else
      query = <<-FOO
        SELECT
        #{QUERY_IEC}
        FROM caso_salud_publicas
        LEFT JOIN muestras
        ON muestras.caso_salud_publica_id = caso_salud_publicas.id
        LEFT JOIN institucions
        ON muestras.institucion_id = institucions.id
        LEFT JOIN entidad_prestadoras
        ON caso_salud_publicas.entidad_prestadora_id = entidad_prestadoras.id
        LEFT JOIN municipios as municipio_origen
        ON caso_salud_publicas.municipio_id = municipio_origen.id
        LEFT JOIN departamentos as departamento_origen
        ON caso_salud_publicas.departamento_id = departamento_origen.id
        LEFT JOIN countries
        ON caso_salud_publicas.country_id = countries.id
        LEFT JOIN barrios
        ON caso_salud_publicas.barrio_id = barrios.id
        LEFT JOIN countries as country_uno
        ON caso_salud_publicas.country_uno_id = country_uno.id
        LEFT JOIN countries as country_dos
        ON caso_salud_publicas.country_dos_id = country_dos.id
        LEFT JOIN countries as country_contacto_uno
        ON caso_salud_publicas.country_id_contacto_uno = country_contacto_uno.id
        LEFT JOIN departamentos as departamento_contacto_uno
        ON caso_salud_publicas.departamento_id_contacto_uno = departamento_contacto_uno.id
        LEFT JOIN municipios as municipio_contacto_uno
        ON caso_salud_publicas.municipio_id_contacto_uno = municipio_contacto_uno.id
        LEFT JOIN usuarios as responsable_investigacion
        ON caso_salud_publicas.responsable_investigacion_id = responsable_investigacion.id
        WHERE #{where.empty? || where == " " ? "TRUE" : where}
      FOO
    end
    puts where_lines.join(" AND ")
    data = copy_to_string(query)
    send_data data, :filename => "dump_iec.csv"
  end

  def download_iec_v2
    where = ""
    where_lines = []
    where_lines << "(contactos.parent_id = #{params[:id]})"
    #where_lines << "(caso_salud_publicas.id = contactos.son_id)"
    where = where_lines.join(" AND ")
    query = <<-FOO
      SELECT
      #{QUERY_IEC}
      FROM contactos
      LEFT JOIN caso_salud_publicas
      ON caso_salud_publicas.id = contactos.son_id
      LEFT JOIN muestras
      ON muestras.caso_salud_publica_id = caso_salud_publicas.id
      LEFT JOIN institucions
      ON muestras.institucion_id = institucions.id
      LEFT JOIN entidad_prestadoras
      ON caso_salud_publicas.entidad_prestadora_id = entidad_prestadoras.id
      LEFT JOIN municipios as municipio_origen
      ON caso_salud_publicas.municipio_id = municipio_origen.id
      LEFT JOIN departamentos as departamento_origen
      ON caso_salud_publicas.departamento_id = departamento_origen.id
      LEFT JOIN countries
      ON caso_salud_publicas.country_id = countries.id
      LEFT JOIN barrios
      ON caso_salud_publicas.barrio_id = barrios.id
      LEFT JOIN countries as country_uno
      ON caso_salud_publicas.country_uno_id = country_uno.id
      LEFT JOIN countries as country_dos
      ON caso_salud_publicas.country_dos_id = country_dos.id
      LEFT JOIN countries as country_contacto_uno
      ON caso_salud_publicas.country_id_contacto_uno = country_contacto_uno.id
      LEFT JOIN departamentos as departamento_contacto_uno
      ON caso_salud_publicas.departamento_id_contacto_uno = departamento_contacto_uno.id
      LEFT JOIN municipios as municipio_contacto_uno
      ON caso_salud_publicas.municipio_id_contacto_uno = municipio_contacto_uno.id
      LEFT JOIN usuarios as responsable_investigacion
      ON caso_salud_publicas.responsable_investigacion_id = responsable_investigacion.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
    FOO
    puts where_lines.join(" AND ")
    data = copy_to_string(query)
    send_data data, :filename => "dump_iec.csv"
  end

  def gestacion
    @caso = CasoSaludPublica.find_by_id params[:id]
    render layout: false
  end

  def update_gestacion
    @caso = CasoSaludPublica.find_by_id params[:id]
    @caso.gestacion_fecha_atencion = params[:gestacion_fecha_atencion]
    @caso.gestacion_edad_gestacional = params[:gestacion_edad_gestacional]
    @caso.gestacion_tiene_enfermedad = params[:gestacion_tiene_enfermedad]
    @caso.gestacion_enfermedad = params[:gestacion_enfermedad]
    @caso.gestacion_control_prenatal = params[:gestacion_control_prenatal]
    @caso.gestacion_gravida = params[:gestacion_gravida]
    @caso.gestacion_para = params[:gestacion_para]
    @caso.gestacion_abortos = params[:gestacion_abortos]
    @caso.gestacion_cesareas = params[:gestacion_cesareas]
    @caso.gestacion_vivos = params[:gestacion_vivos]
    @caso.gestacion_muertos = params[:gestacion_muertos]
    @caso.gestacion_fecha_ultima_regla = params[:gestacion_fecha_ultima_regla]
    @caso.gestacion_ha_tenido = params[:gestacion_ha_tenido]
    @caso.gestacion_vacunas = params[:gestacion_vacunas]
    8.times do |i|
      ActiveRecord::Base.connection.execute("UPDATE caso_salud_publicas SET gestacion_ansiedad[#{i}] = #{params[:gestacion_ansiedad] && params[:gestacion_ansiedad][i.to_s] == "1"} WHERE id = #{@caso.id}")
    end
    @caso.gestacion_ansiedad_otro = params[:gestacion_ansiedad_otro]
    @caso.gestacion_depresion = params[:gestacion_depresion]
    @caso.gestacion_violencia_familiar = params[:gestacion_violencia_familiar]
    @caso.gestacion_estado_nutricional = params[:gestacion_estado_nutricional]
    6.times do |i|
      ActiveRecord::Base.connection.execute("UPDATE caso_salud_publicas SET gestacion_sintomas[#{i}] = #{params[:gestacion_sintomas] && params[:gestacion_sintomas][i.to_s] == "1"} WHERE id = #{@caso.id}")
    end
    @caso.observacion = params[:observacion]
    @caso.save!
  end

  def sin_datos
  end

  def search_sin_datos
    where = ""
    where_lines = []
    where_lines << "(sin_datos = TRUE)"
    where_lines << "(caso.municipio_id = #{current_municipio.id})"
    where_lines << "(caso.numero_documento = '#{params[:numero_documento]}')" if !params[:numero_documento].nil? && !params[:numero_documento].empty?

    where = where_lines.join(" AND ")
    select = <<-FOO
      CASE
        WHEN caso.triage = 1 THEN 'table-success'
        WHEN caso.triage = 2 THEN 'table-warning'
        WHEN caso.triage = 3 THEN 'table-danger'
        ELSE ''
      END AS caso_table_value,
      caso.id AS caso_id,
      caso.tipo_documento AS caso_tipo_documento,
      caso.numero_documento AS caso_numero_documento,
      DATE(caso.created_at) AS caso_created_at,
      archivo.uuid AS archivo_uuid,
      CASE
        WHEN muestra.resultado = 1 THEN 'POR DEFINIR'
        WHEN muestra.resultado = 2 AND muestra.publico = TRUE THEN 'POSITIVO'
        WHEN muestra.resultado = 2 AND muestra.publico = FALSE THEN ''
        WHEN muestra.resultado = 3 THEN 'NEGATIVO'
        WHEN muestra.resultado = 4 THEN 'SE SOLICITA NUEVA MUESTRA'
        ELSE ''
      END AS muestra_resultado_value
    FOO

    query = <<-FOO
      SELECT
      #{select}
      FROM caso_salud_publicas AS caso
      LEFT JOIN muestras AS muestra
      ON muestra.caso_salud_publica_id = caso.id
      LEFT JOIN archivos AS archivo
      ON archivo.muestra_id = muestra.id
      WHERE #{where.empty? || where == " " ? "TRUE" : where}
      ORDER BY caso.created_at DESC
    FOO

    query_paged = <<-FOO
      #{query}
      LIMIT #{params[:size]}
      OFFSET #{params[:index].to_i - 1}
    FOO
    query_counter = <<-FOO
      SELECT COUNT(*)
      FROM caso_salud_publicas AS caso
      LEFT JOIN muestras AS muestra
      ON muestra.caso_salud_publica_id = caso.id
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
end
