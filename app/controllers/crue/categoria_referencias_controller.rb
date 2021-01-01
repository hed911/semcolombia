class Crue::CategoriaReferenciasController < ApplicationController #ACRUALIZADO
  require 'net/http'
  before_action :authenticate_user!

  def index
    @categorias = CategoriaReferencia.all.order('created_at DESC')
  end

  def new; end

  def create
    categoria = CategoriaReferencia.new(
      nombre: params[:nombre]
    )
    categoria.save!
    redirect_to action: 'index'
  end

  def show; end

  def edit
    @categoria = CategoriaReferencia.find(params[:id])
  end

  def update
    categoria = CategoriaReferencia.find(params[:id])
    categoria.nombre = params[:nombre]
    categoria.save!
    redirect_to action: 'index'
  end

  def destroy
    categoria = CategoriaReferencia.find(params[:id])
    categoria.destroy
    redirect_to action: 'index'
  end

  def export_xls
    categorias = CategoriaReferencia.all.order('created_at DESC')
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: 'Datos') do |sheet|
      p.workbook.styles do |s|
        title_style =  s.add_style bg_color: '333333', fg_color: 'FFFFFF', sz: 11, alignment: { horizontal: :center }
        normal_style = s.add_style alignment: { horizontal: :center }

        sheet.add_row ['Nombre'], style: title_style
        for categoria in categorias
          sheet.add_row [categoria.nombre], style: normal_style
        end
      end
    end
    p.use_shared_strings = true
    send_data p.to_stream.read, filename: "categorias-#{Time.now.strftime('%I:%M:%S%p %d-%m-%Y')}.xls"
  end

  def show
    @institucion = Institucion.find_by_id params[:id]
    @categorias = CategoriaReferencia.all.order('created_at ASC')
  end

  def edit_extend
    @institucion = Institucion.find_by_id params[:id]
    @entidad_prestadora = EntidadPrestadora.find_by_id params[:entidad_prestadora_id]
    @categorias = CategoriaReferencia.all.order('created_at ASC')
  end

  def update_extend
    institucion = Institucion.find_by_id params[:id]
    institucion.categoria_referencias = []
    institucion.save!
    params[:categorias].each do |key, _value|
      institucion.categoria_referencias << CategoriaReferencia.find_by_id(key)
    end
    institucion.save!
    redirect_to red_urgencia_crue_entidad_prestadora_path(params[:entidad_prestadora_id])
  end
end
