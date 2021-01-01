class Crue::CargueMasivosController < ApplicationController
  require "net/http"
  before_action :authenticate_user!

  def index
    @cargues_masivos = CargueMasivo.where(municipio: current_municipio).sort_by(&:created_at)
  end

  def show
    @cargue_masivo = CargueMasivo.find_by_id params[:id]
    @cantidad_registros_ok = @cargue_masivo.registros.where(enumeracion_resultado: 1).count
    @cantidad_registros_repetidos = @cargue_masivo.registros.where(enumeracion_resultado: 2).count
    @cantidad_registros_con_error = @cargue_masivo.registros.where(enumeracion_resultado: 3).count
  end

  def create
    file = params[:file]
    raise "Attachment not found" unless file
    if (File.size(file.path).to_f / 2 ** 20) > MAX_FILE_SIZE
      flash[:notice] = "The size must be lower than #{MAX_FILE_SIZE}mb"
      redirect_to crue_cargue_masivos_path
      return
    end
    cargue_masivo = CargueMasivo.new
    cargue_masivo.estado = 1
    cargue_masivo.attachment = file
    cargue_masivo.usuario = current_usuario
    cargue_masivo.municipio = current_municipio
    cargue_masivo.save!
    Resque.enqueue StartCargueMasivoJob, cargue_masivo.id, current_usuario.id
    flash[:notice] = "El analisis y el cargue de los datos del excel ha empezado exitosamente"
    redirect_to crue_cargue_masivos_path
  end

  def destroy
    cargue_masivo = CargueMasivo.find_by_id params[:id]
    Resque.enqueue(DestroyCargueMasivoJob, cargue_masivo.id) if cargue_masivo
    flash[:notice] = "Se esta ejecutando el proceso, espere unos segundos ..."
    redirect_to crue_cargue_masivos_path
  end

  def search_registros
    @cargue_masivo = CargueMasivo.find_by_id params[:id]
    @registros = @cargue_masivo.registros.order("created_at ASC").paginate(page: params[:index].to_i, per_page: 10)
    @cantidad_paginas = @registros.total_pages
    render layout: false
  end
end
