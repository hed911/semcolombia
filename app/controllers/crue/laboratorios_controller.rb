class Crue::LaboratoriosController < ApplicationController #ACTUALIZADA
  require 'net/http'
  before_action :authenticate_user!

  def show
    @laboratorios = Laboratorio.find_by_id params[:id]
    render layout:false
  end

  def index
    @laboratorios = Laboratorio.where(activo:true, municipio: current_municipio)
    @laboratorios = @laboratorios.order('created_at DESC')
    respond_to do |format|
      format.html {}
      format.json { render json: @laboratorios.to_json(only: %i[id nombre]) }
    end
    @laboratorios = @laboratorios
  end

  def search
    term = params[:term] ? params[:term].downcase : ""
    if params[:term]
      @laboratorios = Laboratorio.where(municipio: current_municipio).where('nombre ILIKE ?',"%#{term}%").order('created_at DESC').paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    else
      @laboratorios = Laboratorio.where(municipio: current_municipio).order('created_at DESC').paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    end
    @cantidad_paginas = @laboratorios.total_pages
    render layout: false
  end

  def new

  end

  def create
    laboratorio = Laboratorio.create!
    laboratorio.nombre = params[:nombre]
    laboratorio.direccion = params[:direccion]
    laboratorio.telefono = params[:telefono]
    laboratorio.nit = params[:nit]
    laboratorio.municipio = current_municipio
    laboratorio.coordinacion = params[:coordinacion] == "1"
    laboratorio.save!
    redirect_to action: 'index'
  end

  def edit
    @laboratorio = Laboratorio.find(params[:id])
  end

  def update
    laboratorio = Laboratorio.find(params[:id])
    laboratorio.nombre = params[:nombre]
    laboratorio.direccion = params[:direccion]
    laboratorio.telefono = params[:telefono]
    laboratorio.nit = params[:nit]
    laboratorio.municipio = current_municipio
    laboratorio.coordinacion = params[:coordinacion] == "1"
    laboratorio.save!
    redirect_to action: 'index'
  end

  def destroy
    laboratorio = Laboratorio.find(params[:id])
    laboratorio.destroy
    redirect_to action: 'index'
  end

  def export_xls
    laboratorios = Laboratorio.all
    laboratorios = laboratorios.order('created_at DESC')
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: 'Datos') do |sheet|
      p.workbook.styles do |s|
        title_style =  s.add_style bg_color: '333333', fg_color: 'FFFFFF', sz: 11, alignment: { horizontal: :center }
        normal_style = s.add_style alignment: { horizontal: :center }

        sheet.add_row %w[Nombre Direccion Telefono], style: title_style
        for laboratorio in laboratorios
          sheet.add_row [laboratorio.nombre, laboratorio.direccion, laboratorio.telefono], style: normal_style
        end
      end
    end
    # asdas
    p.use_shared_strings = true
    send_data p.to_stream.read, filename: "institucions-#{Time.now.strftime('%I:%M:%S%p %d-%m-%Y')}.xls"
  end

  def search_csv
    render_csv
  end

  def render_csv
    set_file_headers
    set_streaming_headers
    response.status = 200
    self.response_body = csv_lines
  end

  def set_file_headers
    file_name = 'instituciones.xls'
    headers['Content-Type'] = 'text/xls; charset=utf-8; header=present'
    headers['Content-disposition'] = "attachment; filename=\"#{file_name}\""
  end

  def set_streaming_headers
    headers['X-Accel-Buffering'] = 'no'
    headers['Cache-Control'] ||= 'no-cache'
    headers.delete('Content-Length')
  end

  def csv_lines
    Enumerator.new do |y|
      counter = 1
      y << InstitucionHelper.xls_header
      Laboratorio.where(municipio:current_municipio).order('nombre ASC').find_in_batches(batch_size: 300) do |group|
        group.each do |item|
          y << InstitucionHelper.to_xls_row(item)
        end
      end
      y << InstitucionHelper.xls_footer
    end
  end
end
