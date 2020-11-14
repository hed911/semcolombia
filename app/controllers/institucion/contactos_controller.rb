class Institucion::ContactosController < ApplicationController
  require "net/http"
  before_action :authenticate_usuario!

  def index
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @entidades_prestadoras = current_municipio.entidad_prestadoras.where(especial: false).order("nombre ASC")
    @aseguradoras = Aseguradora.all.order("nombre ASC")
    render layout: false
  end

  def new
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
  end

  def create
    if CasoSaludPublica.find_by_tipo_documento_and_numero_documento_and_municipio_id(params[:tipo_documento], params[:numero_documento], current_municipio.id)
      @error = "Ya existe un registro con el numero de documento dado"
      return
    end
    @parent = CasoSaludPublica.find params[:caso_salud_publica_id]
    @caso = CasoSaludPublica.create!
    @caso.primer_nombre = params[:primer_nombre]
    @caso.primer_apellido = params[:primer_apellido]
    @caso.segundo_nombre = params[:segundo_nombre]
    @caso.segundo_apellido = params[:segundo_apellido]
    @caso.fecha_nacimiento = params[:fecha_nacimiento]
    @caso.edad = params[:edad]
    @caso.unidad_medida = params[:unidad_medida]
    @caso.tipo_documento = params[:tipo_documento]
    @caso.numero_documento = params[:numero_documento].strip
    @caso.direccion = params[:direccion]
    @caso.telefono = params[:telefono]
    @caso.relacionado = true
    @caso.sexo = params[:sexo]

    @caso.institucion = current_institucion
    @caso.entidad_prestadora = current_institucion.entidad_prestadora
    @caso.aseguradora = Aseguradora.find_by_id(params[:aseguradora_id])

    @caso.departamento = current_municipio.departamento
    @caso.municipio = current_municipio
    @caso.departamento_origen = Departamento.find_by_id(params[:departamento_id])
    @caso.municipio_origen = Municipio.find_by_id(params[:municipio_id])

    @caso.nivel = @parent.nivel + 1
    @caso.estado = 1
    @caso.estado_seguimiento = 1
    @caso.usuario = current_usuario
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
end
