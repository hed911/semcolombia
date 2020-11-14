class Crue::InstitucionsController < ApplicationController #ACTUALIZADA
  require 'net/http'
  before_action :authenticate_usuario!

  def sedes
    @institucion = Institucion.find_by_id params[:id]
  end

  def show
    @institucion = Institucion.find_by_id params[:id]
    render layout:false
  end

  def index
    @institucions = Institucion.where(activo:true, municipio: current_municipio, parent:nil)
    @institucions = @institucions.order('created_at DESC')
    respond_to do |format|
      format.html {}
      format.json { render json: @institucions.to_json(only: %i[id nombre]) }
    end
    @institucions = @institucions
  end

  def search
    term = params[:term] ? params[:term].downcase : ""
    if params[:term]
      @institucions = Institucion.where(parent:nil, municipio: current_municipio).where('nombre ILIKE ?',"%#{term}%").order('created_at DESC').paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    else
      @institucions = Institucion.where(parent:nil, municipio: current_municipio).order('created_at DESC').paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    end
    @cantidad_paginas = @institucions.total_pages
    render layout: false
  end

  def new
    @parent = Institucion.find_by_id params[:parent_id]
    @departamentos = Departamento.all.order('nombre ASC')
    @municipios = []
    @entidades_prestadoras = current_municipio.entidad_prestadoras.order('created_at ASC')
  end

  def create
    institucion = Institucion.create!
    institucion.codigo = params[:codigo]
    institucion.numero_sede = params[:numero_sede]
    institucion.nombre = params[:nombre]
    institucion.direccion = params[:direccion]
    institucion.telefono = params[:telefono]
    institucion.email = params[:email]
    institucion.nit = params[:nit]
    institucion.dv = params[:dv]
    institucion.clase_persona = params[:clase_persona]
    institucion.naju_nombre = params[:naju_nombre]
    institucion.ese = params[:ese]
    institucion.caracter = params[:caracter]
    institucion.grse_nombre = params[:grse_nombre]
    institucion.serv_nombre = params[:serv_nombre]
    institucion.ambulatorio = params[:ambulatorio]
    institucion.hospitalario = params[:hospitalario]
    institucion.unidad_movil = params[:unidad_movil]
    institucion.domiciliario = params[:domiciliario]
    institucion.atiende_salud_mental = params[:atiende_salud_mental] == "1"
    institucion.otras_extramural = params[:otras_extramural]
    institucion.centro_referencia = params[:centro_referencia]
    institucion.institucion_remisora = params[:institucion_remisora]
    institucion.fecha_apertura = params[:fecha_apertura]
    institucion.fecha_cierre = params[:fecha_cierre]
    institucion.numero_distintivo = params[:numero_distintivo]
    institucion.numero_sede_principal = params[:numero_sede_principal]
    institucion.activo = true
    institucion.latitude = params[:latitude]
    institucion.longitude = params[:longitude]
    institucion.nivel = params[:nivel]
    institucion.nivel_complejidad = params[:nivel_complejidad]
    institucion.municipio = current_municipio
    institucion.email_contacto_uno = params[:email_contacto_uno]
    institucion.email_contacto_dos = params[:email_contacto_dos]
    institucion.email_contacto_tres = params[:email_contacto_tres]
    institucion.email_contacto_cuatro = params[:email_contacto_cuatro]
    institucion.email_contacto_cinco = params[:email_contacto_cinco]
    institucion.telefono_contacto_uno = params[:telefono_contacto_uno]
    institucion.telefono_contacto_dos = params[:telefono_contacto_dos]
    institucion.telefono_contacto_tres = params[:telefono_contacto_tres]
    institucion.telefono_contacto_cuatro = params[:telefono_contacto_cuatro]
    institucion.telefono_contacto_cinco = params[:telefono_contacto_cinco]
    institucion.municipio_alterno = Municipio.find_by_id params[:municipio_id]
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
    institucion.roles = roles
    institucion.parent = Institucion.find_by_id params[:parent_id]
    institucion.save!
    if institucion.parent
      redirect_to sedes_crue_institucion_path(institucion.parent.id)
    else
      redirect_to action: 'index'
    end
  end

  def edit
    @institucion = Institucion.find(params[:id])
    @departamentos = Departamento.all.order('nombre ASC')
    @municipios = @institucion.municipio_alterno.nil? ? [] : @institucion.municipio_alterno.departamento.municipios.order('nombre ASC')
    @entidades_prestadoras = current_municipio.entidad_prestadoras.order('created_at ASC')
  end

  def update
    institucion = Institucion.find(params[:id])
    institucion.codigo = params[:codigo]
    institucion.numero_sede = params[:numero_sede]
    institucion.nombre = params[:nombre]
    institucion.direccion = params[:direccion]
    institucion.telefono = params[:telefono]
    institucion.email = params[:email]
    institucion.nit = params[:nit]
    institucion.dv = params[:dv]
    institucion.clase_persona = params[:clase_persona]
    institucion.naju_nombre = params[:naju_nombre]
    institucion.ese = params[:ese]
    institucion.caracter = params[:caracter]
    institucion.grse_nombre = params[:grse_nombre]
    institucion.serv_nombre = params[:serv_nombre]
    institucion.ambulatorio = params[:ambulatorio]
    institucion.hospitalario = params[:hospitalario]
    institucion.unidad_movil = params[:unidad_movil]
    institucion.domiciliario = params[:domiciliario]
    institucion.atiende_salud_mental = params[:atiende_salud_mental] == "1"
    institucion.otras_extramural = params[:otras_extramural]
    institucion.centro_referencia = params[:centro_referencia]
    institucion.institucion_remisora = params[:institucion_remisora]
    institucion.fecha_apertura = params[:fecha_apertura]
    institucion.fecha_cierre = params[:fecha_cierre]
    institucion.numero_distintivo = params[:numero_distintivo]
    institucion.numero_sede_principal = params[:numero_sede_principal]
    institucion.activo = params[:activo]
    institucion.latitude = params[:latitude]
    institucion.longitude = params[:longitude]
    institucion.nivel = params[:nivel]
    institucion.nivel_complejidad = params[:nivel_complejidad]
    institucion.email_contacto_uno = params[:email_contacto_uno]
    institucion.email_contacto_dos = params[:email_contacto_dos]
    institucion.email_contacto_tres = params[:email_contacto_tres]
    institucion.email_contacto_cuatro = params[:email_contacto_cuatro]
    institucion.email_contacto_cinco = params[:email_contacto_cinco]
    institucion.email_contacto_seis = params[:email_contacto_seis]
    institucion.telefono_contacto_uno = params[:telefono_contacto_uno]
    institucion.telefono_contacto_dos = params[:telefono_contacto_dos]
    institucion.telefono_contacto_tres = params[:telefono_contacto_tres]
    institucion.telefono_contacto_cuatro = params[:telefono_contacto_cuatro]
    institucion.telefono_contacto_cinco = params[:telefono_contacto_cinco]
    institucion.telefono_contacto_seis = params[:telefono_contacto_seis]
    institucion.municipio_alterno = Municipio.find_by_id params[:municipio_id]
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
    institucion.roles = roles
    institucion.save!
    if institucion.parent
      redirect_to sedes_crue_institucion_path(institucion.parent.id)
    else
      redirect_to action: 'index'
    end
  end

  def destroy
    institucion = Institucion.find(params[:id])
    parent = institucion.parent
    institucion.sedes.each do |sede|
      sede.destroy!
    end
    institucion.destroy
    if parent
      redirect_to sedes_crue_institucion_path(parent.id)
    else
      redirect_to action: 'index'
    end
  end

  def export_xls
    institucions = Institucion.all
    institucions = institucions.order('created_at DESC')
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: 'Datos') do |sheet|
      p.workbook.styles do |s|
        title_style =  s.add_style bg_color: '333333', fg_color: 'FFFFFF', sz: 11, alignment: { horizontal: :center }
        normal_style = s.add_style alignment: { horizontal: :center }

        sheet.add_row %w[Nit Roles Codigo Nombre Nivel Direccion Telefono], style: title_style
        for institucion in institucions
          sheet.add_row [institucion.nit, institucion.roles_value, institucion.codigo, institucion.nombre, 'Hospital', institucion.direccion, institucion.telefono], style: normal_style
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
      Institucion.where(municipio:current_municipio).order('nombre ASC').find_in_batches(batch_size: 300) do |group|
        group.each do |item|
          y << InstitucionHelper.to_xls_row(item)
        end
      end
      y << InstitucionHelper.xls_footer
    end
  end
end
