class Crue::EntidadPrestadorasController < ApplicationController #ACTUALIZADA
  require 'net/http'
  before_action :authenticate_user!

  def index
    @entidades_prestadoras = EntidadPrestadora.where(especial:false).order('created_at DESC')
    @entidades_prestadoras_especiales = EntidadPrestadora.where(especial:true).order('created_at DESC')
  end

  def new

  end

  def create
    roles = ''
    counter = 1
    if params[:roles]
      params[:roles].each do |key, _value|
        roles = if counter > 1
                  "#{roles},#{key}"
                else
                  key.to_s
                end
        counter += 1
      end
    end
    entidad_prestadora = EntidadPrestadora.create!(
      nombre: params[:nombre],
      especial: params.key?("especial"),
      roles: roles
    )

    redirect_to action: 'index'
  end

  def show; end

  def edit
    @entidad_prestadora = EntidadPrestadora.find(params[:id])
  end

  def update
    entidad_prestadora = EntidadPrestadora.find(params[:id])
    entidad_prestadora.codigo = params[:codigo]
    entidad_prestadora.nombre = params[:nombre]
    entidad_prestadora.especial = params.key?("especial")
    roles = ''
    counter = 1
    if params[:roles]
      params[:roles].each do |key, _value|
        roles = if counter > 1
                  "#{roles},#{key}"
                else
                  key.to_s
                end
        counter += 1
      end
    end
    entidad_prestadora.roles = roles
    entidad_prestadora.save!
    redirect_to action: 'index'
  end

  def destroy
    entidad_prestadora = EntidadPrestadora.find(params[:id])
    entidad_prestadora.destroy
    redirect_to action: 'index'
  end

  def export_xls
    entidades_prestadoras = EntidadPrestadora.all.order('created_at DESC')
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: 'Datos') do |sheet|
      p.workbook.styles do |s|
        title_style =  s.add_style bg_color: '333333', fg_color: 'FFFFFF', sz: 11, alignment: { horizontal: :center }
        normal_style = s.add_style alignment: { horizontal: :center }

        sheet.add_row ['Nombre'], style: title_style
        for entidad_prestadora in entidades_prestadoras
          sheet.add_row [entidad_prestadora.nombre], style: normal_style
        end
      end
    end
    p.use_shared_strings = true
    send_data p.to_stream.read, filename: "entidades_prestadoras-#{Time.now.strftime('%I:%M:%S%p %d-%m-%Y')}.xls"
  end

  def get_instituciones_despacho
    hash = {}
    hash[:municipio] = Municipio.find_by_id(params[:municipio_id])
    hash[:activo] = true
    entidad_prestadora = EntidadPrestadora.find params[:id]
    @instituciones_red = []
    @instituciones = []
    Institucion.where(hash).order('nombre ASC').each do |institucion|
      if entidad_prestadora.institucions.include?(institucion)
        @instituciones_red << institucion
      else
        @instituciones << institucion
      end
    end
  end

  def get_instituciones_destino
    hash = {}
    hash[:municipio] = Municipio.find_by_id(params[:municipio_id])
    hash[:activo] = true
    entidad_prestadora = EntidadPrestadora.find params[:id]
    @instituciones_red = []
    @instituciones = []
    Institucion.where(hash).order('nombre ASC').each do |institucion|
      if entidad_prestadora.institucions.include?(institucion)
        @instituciones_red << institucion
      else
        @instituciones << institucion
      end
    end
  end

  def red_urgencia
    @entidad_prestadora = EntidadPrestadora.find_by_id params[:id]
    @instituciones = Institucion.where(municipio:current_municipio, entidad_prestadora:nil).order("nombre ASC")#.group_by(&:nivel)
  end

  def toggle_habilitacion_hospital
    entidad_prestadora = EntidadPrestadora.find_by_id params[:id]
    institucion = Institucion.find_by_id params[:institucion_id]
    if entidad_prestadora.institucions.include?(institucion)
      entidad_prestadora.institucions.delete(institucion)
    else
      entidad_prestadora.institucions << institucion
    end
    entidad_prestadora.save!
    redirect_to red_urgencia_crue_entidad_prestadora_path(entidad_prestadora.id)
  end

  def subir_archivo
    @entidad_prestadora = EntidadPrestadora.find_by_id params[:entidad_prestadora_id]
    @institucion = Institucion.find_by_id params[:id]
  end

  def do_subir_archivo
    @entidad_prestadora = EntidadPrestadora.find_by_id params[:entidad_prestadora_id]
    @institucion = Institucion.find_by_id params[:id]
    redirect_to red_urgencia_crue_entidad_prestadora_path(@entidad_prestadora.id)
  end

  def toggle_habilitacion
    entidad_prestadora = EntidadPrestadora.find_by_id params[:id]
    municipio = current_municipio
    if municipio.entidad_prestadoras.include?(entidad_prestadora)
      municipio.entidad_prestadoras.delete(entidad_prestadora)
    else
      municipio.entidad_prestadoras << entidad_prestadora
    end
    municipio.save!
    redirect_to crue_entidad_prestadoras_path
  end

end
