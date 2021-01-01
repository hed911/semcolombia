# encoding: UTF-8

class EntidadPrestadora::CasoSaludPublicasController < ApplicationController
  before_action :authenticate_user!

  def index
    #OJO FALTA ASOCIAR QUE EL ARRAY DE ABAJO SOLO LLEVE LAS INSTITUCIONES DE LA EAPB ACTUAL
    @instituciones = current_usuario.entidad_prestadora.institucions.where(activo: true, municipio: current_municipio).order("nombre ASC")
    @countries = Country.all.order("nombre ASC")
    @usuarios = []
    Usuario.where(es_super_admin: false, municipio: current_municipio, entidad_prestadora: current_usuario.entidad_prestadora).each do |usuario|
      @usuarios << usuario if usuario.roles_array.include?(ROLES_USUARIOS_ENTIDADES_PRESTADORAS[3])
    end
  end

  def actuales
  end

  def search_actuales
    @casos = CasoSaludPublica.where(municipio: current_municipio, entidad_prestadora: current_usuario.entidad_prestadora, estado: ESTADO_SP_VIGENTE).includes([:muestras, :entidad_prestadora, :usuario]).order("created_at DESC").paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @casos.total_pages
    render template: "entidad_prestadora/caso_salud_publicas/search", layout: false
  end

  def edit
    @caso = CasoSaludPublica.find_by_id params[:id]
    @llamada = Llamada.find_by_id params[:llamada_id]
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
    @instituciones = Institucion.where(activo: true, municipio: current_municipio).order("nombre ASC")
    @countries = Country.all.order("nombre ASC")
    @entidades_prestadoras = EntidadPrestadora.where(especial: false).order("nombre ASC")
    @departamentos = Departamento.all.order("nombre ASC")
    @colombia = Country.find_by_codigo("co")
    @municipios = @caso.departamento_origen.nil? ? [] : @caso.departamento_origen.municipios.order("nombre ASC")
    @barrios = @caso.municipio_origen.nil? ? [] : @caso.municipio_origen.barrios.order("nombre ASC")
    @municipios_contacto_uno = @caso.departamento_contacto_uno.nil? ? [] : @caso.departamento_contacto_uno.municipios.order("nombre ASC")
    render layout: false
  end

  def new
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
    @caso.entidad_prestadora = current_usuario.entidad_prestadora
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
    @entidades_prestadoras = EntidadPrestadora.where(especial: false).order("nombre ASC")
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

    @caso.save!
    @caso.calculate_triage
  end

  def search
    hash = {}
    hash[:created_at] = (Date.strptime(params[:start_date], "%Y-%m-%d").beginning_of_day..Date.strptime(params[:end_date], "%Y-%m-%d").end_of_day) if params[:start_date] != "" && params[:end_date] != ""
    hash[:numero_oficial] = params[:numero_oficial] if params[:numero_oficial] && params[:numero_oficial] != ""
    hash[:id] = params[:id] if params[:id] && params[:id] != ""
    hash[:numero_documento] = params[:numero_documento].strip if params[:numero_documento] && params[:numero_documento] != ""
    #hash[:entidad_prestadora] = current_usuario.entidad_prestadora
    hash[:municipio] = current_municipio
    hash[:servicio] = params[:servicio] if params[:servicio] && params[:servicio] != ""
    hash[:country] = Country.find_by_id(params[:country_id]) if params[:country_id] && params[:country_id] != ""
    hash[:usuario] = Usuario.find_by_id(params[:usuario_id]) if params[:usuario_id] && params[:usuario_id] != ""
    hash[:sexo] = params[:sexo] if params[:sexo] && params[:sexo] != ""
    hash[:estado] = params[:estado] if params[:estado] && params[:estado] != ""
    hash[:estado_enfermedad] = params[:estado_enfermedad] if params[:estado_enfermedad] && params[:estado_enfermedad] != ""
    hash[:publico] = true if params[:estado_enfermedad] == "2"
    hash[:reinfeccion] = true if params[:estado_enfermedad] == "5"
    hash[:estado_seguimiento] = params[:estado_seguimiento] if params[:estado_seguimiento] && params[:estado_seguimiento] != ""
    hash[:triage] = params[:triage] if params[:triage] && params[:triage] != ""
    hash[:tipo_contagio] = params[:tipo_contagio] if params[:tipo_contagio] && params[:tipo_contagio] != ""
    @casos = CasoSaludPublica.where(hash).includes([:muestras, :entidad_prestadora, :usuario])
    @casos = @casos.where("primer_nombre ILIKE '%#{params[:primer_nombre]}%'") if !params[:primer_nombre].nil? && !params[:primer_nombre].empty?
    @casos = @casos.where("primer_apellido ILIKE '%#{params[:primer_apellido]}%'") if !params[:primer_apellido].nil? && !params[:primer_apellido].empty?
    @casos = @casos.order("caso_salud_publicas.created_at DESC").paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @casos.total_pages
    render layout: false
  end

  def edit_crue
    @caso = CasoSaludPublica.find_by_id params[:id]
  end

  def update_crue
    @caso = CasoSaludPublica.find_by_id params[:id]
    @caso.servicio = params[:servicio]
    @caso.fallecido = params[:fallecido] == "1"
    @caso.save!
  end

  def destroy
    caso = CasoSaludPublica.find_by_id params[:id]
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

  def existe
    caso = CasoSaludPublica.find_by_tipo_documento_and_numero_documento_and_municipio_id(params[:tipo_documento], params[:numero_documento], current_municipio.id)
    render json: { result: !caso.nil? }.to_json
  end

  def owned
    Pusher.trigger("caso_#{params[:id]}", "owned", id: current_usuario.id, nombre: current_usuario.nombre_completo)
    render json: { result: "OK" }.to_json
  end
end
