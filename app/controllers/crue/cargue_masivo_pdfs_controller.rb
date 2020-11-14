class Crue::CargueMasivoPdfsController < ApplicationController
  require "net/http"
  before_action :authenticate_usuario!

  def index
    @cargues_masivos = CargueMasivoPdf.where(municipio: current_municipio).sort_by(&:created_at)
    @laboratorios = Laboratorio.where(coordinacion: [nil, false], municipio: current_municipio).sort_by(&:nombre)
  end

  def show
    @cargue_masivo = CargueMasivoPdf.find_by_id params[:id]
    @cantidad_registros_ok = @cargue_masivo.registros.where(enumeracion_resultado: 1).count
    @cantidad_registros_con_error = @cargue_masivo.registros.where.not(enumeracion_resultado: 1).count
  end

  def create
    file = params[:file]
    raise "No adjunt\u00F3 un archivo" unless file
    if (File.size(file.path).to_f / 2 ** 20) > 20
      flash[:notice] = "El tama\u00F1o del archivo no debe superar los 20mb, intente hacer que el archivo tenga menos registros"
      redirect_to crue_cargue_masivo_pdfs_path
      return
    end
    cargue_masivo = CargueMasivoPdf.new
    cargue_masivo.estado = 1
    cargue_masivo.archivo = file
    cargue_masivo.usuario = current_usuario
    cargue_masivo.municipio = current_municipio
    cargue_masivo.laboratorio = Laboratorio.find_by_id(params[:laboratorio_id])
    cargue_masivo.save!
    Resque.enqueue StartCargueMasivoPdfJob, cargue_masivo.id, current_usuario.id
    flash[:notice] = "El analisis y el cargue de los datos del excel ha empezado exitosamente"
    redirect_to crue_cargue_masivo_pdfs_path
  end

  def destroy
    cargue_masivo = CargueMasivoPdf.find_by_id params[:id]
    Resque.enqueue(DestroyCargueMasivoPdfJob, cargue_masivo.id) if cargue_masivo
    flash[:notice] = "Se esta ejecutando el proceso, espere unos segundos ..."
    redirect_to crue_cargue_masivo_pdfs_path
  end

  def search_registros
    @cargue_masivo = CargueMasivoPdf.find_by_id params[:id]
    @registros = @cargue_masivo.registros.order("created_at ASC").paginate(page: params[:index].to_i, per_page: 10)
    @cantidad_paginas = @registros.total_pages
    render layout: false
  end

  def pendientes
    @cargue_masivo = CargueMasivoPdf.find_by_id params[:id]
  end

  def search_pendientes
    hash = { estado_alterno: 1, tipo: 1 }
    hash_cargue_masivo = {}
    hash_cargue_masivo["cargue_masivo_pdfs.id"] = params[:id]
    hash[:numero_documento] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
    if current_usuario.municipio
      hash_cargue_masivo["cargue_masivo_pdfs.municipio_id"] = current_municipio.id
    end
    @registros = RegistroPdf.where(hash).includes([:cargue_masivo_pdf]).where(hash_cargue_masivo)
    @registros = @registros.order("registro_pdfs.created_at DESC").paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @registros.total_pages
    @cantidad_registros = @registros.count
    render layout: false
  end

  def resolver
    @registro = RegistroPdf.find_by_id params[:id]
    @caso = CasoSaludPublica.where(numero_documento: @registro.numero_documento).first
    @muestras = @caso.muestras.where(resultado: [1, 2, 3], laboratorio: @registro.cargue_masivo_pdf.laboratorio).to_a
    @muestras.each do |muestra|
      @muestras.delete(muestra) if muestra.archivos.any?
    end
    render layout: false
  end

  def do_resolver
    registro = RegistroPdf.find_by_id params[:id]
    muestra = Muestra.find_by_id params[:muestra_id]
    muestra.archivos = [registro.archivo]
    muestra.resultado = registro.resultado
    muestra.estado = 5
    muestra.fecha_procesado_interna = Time.now
    muestra.save!
    registro.estado_alterno = 2
    registro.save!
    redirect_to pendientes_crue_cargue_masivo_pdf_path(registro.cargue_masivo_pdf.id)
  end
end
