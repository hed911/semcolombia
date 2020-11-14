class Crue::ContactosController < ApplicationController
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
    render layout: false
  end

  def new
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
  end

  def create
    @parent = CasoSaludPublica.find params[:caso_salud_publica_id]
    if CasoSaludPublica.find_by_tipo_documento_and_numero_documento_and_municipio_id(params[:tipo_documento], params[:numero_documento], current_municipio.id)
      @error = "Ya existe un registro con el numero de documento dado"
      return
    end
    @caso = CasoSaludPublica.create!
    @caso.relacionado = true
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

    @caso.ciudad_uno = params[:ciudad_uno]
    @caso.ciudad_dos = params[:ciudad_dos]
    @caso.fecha_ingreso_uno = params[:fecha_ingreso_uno]
    @caso.fecha_ingreso_dos = params[:fecha_ingreso_dos]
    @caso.fecha_salida_uno = params[:fecha_salida_uno]
    @caso.fecha_salida_dos = params[:fecha_salida_dos]

    @caso.nivel = @parent.nivel + 1
    @caso.estado = ESTADO_SP_VIGENTE
    @caso.estado_seguimiento = 1
    @caso.estado_enfermedad = 1
    @caso.fecha_actualizacion_estado_enfermedad = Time.now
    @caso.usuario = current_usuario
    @caso.save!
    @caso.calculate_triage
    @caso.created_at = Time.strptime(params[:created_at], "%Y-%m-%dT%T") if !params[:created_at].nil?
    @caso.save!

    @contacto = Contacto.create! parentezco: params[:parentezco], tipo_contacto: params[:tipo_contacto]
    @contacto.parent = @parent
    @contacto.son = @caso
    @contacto.save!
  end

  def destroy
    @parent = CasoSaludPublica.find_by_id params[:caso_salud_publica_id]
    @son = CasoSaludPublica.find_by_id params[:id]
    contacto = Contacto.where(parent: @parent, son: @son).first
    @son.destroy!
    contacto.destroy!
  end

  def desenlazar
    @parent = CasoSaludPublica.find_by_id params[:caso_salud_publica_id]
    @son = CasoSaludPublica.find_by_id params[:id]
    contacto = Contacto.where(parent: @parent, son: @son).first
    contacto.destroy!
  end
end
