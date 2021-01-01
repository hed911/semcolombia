class Crue::HistorialUrgenciasController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def last_recurso
    institucion = Institucion.find_by_id params[:id]
    render json: institucion.historial_urgencias.last.to_json(methods: [:created_at_formatted])
  end

  def consulta
    totales = {
      heridos_arma_fuego: 0,
      heridos_arma_blanca: 0,
      heridos_arma_contundente: 0,
      heridos_accidente_transito: 0,
      urgencias_totales_atendidas: 0,
      pacientes_observacion: 0,
      cirugias_urgencias: 0
    }
    @start_date_object = !params[:start_date].nil? ? Time.strptime(params[:start_date], '%Y-%m-%d') : Time.now - 1.days
    @start_date_object = @start_date_object.beginning_of_day
    @start_date = @start_date_object.strftime('%Y-%m-%d')
    @end_date_object = !params[:end_date].nil? ? Time.strptime(params[:end_date], '%Y-%m-%d') : Time.now - 1.days
    @end_date_object = @end_date_object.end_of_day
    @end_date = @end_date_object.strftime('%Y-%m-%d')
    @historiales = []
    Institucion.where(activo:true, municipio:current_municipio).order('created_at ASC').each do |institucion|
      next unless institucion.roles_array.include?(ROLES_INSTITUCIONES[4])
      parciales = {}
      parciales[:heridos_arma_fuego] = 0
      parciales[:heridos_arma_blanca] = 0
      parciales[:heridos_arma_contundente] = 0
      parciales[:heridos_accidente_transito] = 0
      parciales[:urgencias_totales_atendidas] = 0
      parciales[:pacientes_observacion] = 0
      parciales[:cirugias_urgencias] = 0
      HistorialUrgencia.where(institucion: institucion, created_at: @start_date_object..@end_date_object).each do |registro|
        parciales[:heridos_arma_fuego] += registro.heridos_arma_fuego || 0
        parciales[:heridos_arma_blanca] += registro.heridos_arma_blanca || 0
        parciales[:heridos_arma_contundente] += registro.heridos_arma_contundente || 0
        parciales[:heridos_accidente_transito] += registro.heridos_accidente_transito || 0
        parciales[:urgencias_totales_atendidas] += registro.urgencias_totales_atendidas || 0
        parciales[:pacientes_observacion] += registro.pacientes_observacion || 0
        parciales[:cirugias_urgencias] += registro.cirugias_urgencias || 0
      end
      @historiales << {
        institucion: institucion,
        registro: parciales
      }
      totales[:heridos_arma_fuego] += parciales[:heridos_arma_fuego]
      totales[:heridos_arma_blanca] += parciales[:heridos_arma_blanca]
      totales[:heridos_arma_contundente] += parciales[:heridos_arma_contundente]
      totales[:heridos_accidente_transito] += parciales[:heridos_accidente_transito]
      totales[:urgencias_totales_atendidas] += parciales[:urgencias_totales_atendidas]
      totales[:pacientes_observacion] += parciales[:pacientes_observacion]
      totales[:cirugias_urgencias] += parciales[:cirugias_urgencias]
    end

    items = [
      { tag: 'Arma fuego', value: totales[:heridos_arma_fuego] },
      { tag: 'Arma blanca', value: totales[:heridos_arma_blanca] },
      { tag: 'Arma contundente', value: totales[:heridos_arma_contundente] },
      { tag: 'Accidente transito', value: totales[:heridos_accidente_transito] },
      { tag: 'Urgencias totales', value: totales[:urgencias_totales_atendidas] },
      { tag: 'Pacientes en observacion', value: totales[:pacientes_observacion] },
      { tag: 'Cirugias de urgencias', value: totales[:cirugias_urgencias] }
    ]

    @json_historiales = Jbuilder.encode do |json|
      json.array! items do |item|
        json.set! :tag, item[:tag]
        json.set! :value, item[:value]
      end
    end
    @historiales << { institucion: nil, registro: totales }
  end

  def do_consulta
    redirect_to "#{consulta_historial_urgencias_path}?start_date=#{params[:start_date].first}&end_date=#{params[:end_date].first}"
  end

  def index
    totales = {
      heridos_arma_fuego: 0,
      heridos_arma_blanca: 0,
      heridos_arma_contundente: 0,
      heridos_accidente_transito: 0,
      urgencias_totales_atendidas: 0,
      pacientes_observacion: 0,
      cirugias_urgencias: 0
    }
    @datetime_object = !params[:datetime].nil? ? Time.strptime(params[:datetime], '%Y-%m-%dT%T') : Time.now
    @datetime = @datetime_object.strftime('%Y-%m-%dT%T')
    @historiales = []
    Institucion.where(activo:true, municipio: current_municipio).order('created_at ASC').each do |institucion|
      next unless institucion.roles_array.include?(ROLES_INSTITUCIONES[4])
      registro = HistorialUrgencia.where(institucion: institucion).where(created_at: Time.now.beginning_of_day..Time.now.end_of_day).last
      @historiales << {
        institucion: institucion,
        registro: registro
      }
      next unless registro
      totales[:heridos_arma_fuego] += registro.heridos_arma_fuego || 0
      totales[:heridos_arma_blanca] += registro.heridos_arma_blanca || 0
      totales[:heridos_arma_contundente] += registro.heridos_arma_contundente || 0
      totales[:heridos_accidente_transito] += registro.heridos_accidente_transito || 0
      totales[:urgencias_totales_atendidas] += registro.urgencias_totales_atendidas || 0
      totales[:pacientes_observacion] += registro.pacientes_observacion || 0
      totales[:cirugias_urgencias] += registro.cirugias_urgencias || 0
    end

    @historiales.sort! { |a, b| a[:registro] && b[:registro] ? a[:registro].created_at <=> b[:registro].created_at : a[:registro] ? -1 : 1 }
    @historiales.reverse!
    @historiales << { institucion: nil, registro: totales }

    items = [
      { tag: 'Arma fuego', value: totales[:heridos_arma_fuego] },
      { tag: 'Arma blanca', value: totales[:heridos_arma_blanca] },
      { tag: 'Arma contundente', value: totales[:heridos_arma_contundente] },
      { tag: 'Accidente transito', value: totales[:heridos_accidente_transito] },
      { tag: 'Urgencias totales', value: totales[:urgencias_totales_atendidas] },
      { tag: 'Pacientes en observacion', value: totales[:pacientes_observacion] },
      { tag: 'Cirugias de urgencias', value: totales[:cirugias_urgencias] }
    ]

    @json_historiales = Jbuilder.encode do |json|
      json.array! items do |item|
        json.set! :tag, item[:tag]
        json.set! :value, item[:value]
      end
    end
    # raise "tipo:#{@json_historiales_sangres}"
  end

  def change_date
    redirect_to "#{historial_urgencias_path}?datetime=#{params[:datetime]}"
  end

  def new
    @instituciones = []
    Institucion.where(activo:true, nivelinstitucion: Nivelinstitucion.find_by_id(2)).sort_by(&:created_at).each do |institucion|
      @instituciones << institucion if institucion.roles_array.include?(ROLES_INSTITUCIONES[4])
    end
  end

  def create
    historial = HistorialUrgencia.where(institucion_id: params[:ips], created_at: Time.now.beginning_of_day..Time.now.end_of_day).first
    if historial
      historial.attributes = params
    else
      historial = HistorialUrgencia.create! params
    end
    historial.institucion = Institucion.find_by_id params[:ips]
    historial.usuario = current_usuario
    historial.created_at = params[:fecha]
    historial.save!
    flash[:notice] = "Urgencias de #{historial.institucion.nombre} actualizados correctamente"
    redirect_to new_historial_urgencia_path
  end

  def edit
    @institucion = Institucion.find_by_id params[:id]
    @historial = HistorialUrgencia.where(institucion: @institucion, created_at: Time.now.beginning_of_day..Time.now.end_of_day).first
    render layout: false
  end

  def update
    params_ = {
      heridos_arma_fuego: params[:heridos_arma_fuego],
      heridos_arma_blanca: params[:heridos_arma_blanca],
      heridos_arma_contundente: params[:heridos_arma_contundente],
      heridos_accidente_transito: params[:heridos_accidente_transito],
      urgencias_totales_atendidas: params[:urgencias_totales_atendidas],
      pacientes_observacion: params[:pacientes_observacion],
      cirugias_urgencias: params[:cirugias_urgencias]
    }

    date_object = Date.strptime(params[:fecha], '%Y-%m-%d')
    created_at = Time.zone.parse("#{date_object.year}-#{date_object.month}-#{date_object.day} #{Time.now.hour}:#{Time.now.min}:#{Time.now.sec}")
    historial = HistorialUrgencia.where(institucion_id: params[:id], created_at: created_at.beginning_of_day..created_at.end_of_day).first
    if historial
      historial.attributes = params_
    else
      historial = HistorialUrgencia.create! params_
    end
    historial.institucion = Institucion.find_by_id params[:id]
    historial.usuario = current_usuario
    historial.created_at = created_at
    historial.save!
    flash[:notice] = "Urgencias de #{historial.institucion.nombre} actualizados correctamente"
    redirect_to historial_urgencias_path
  end

  def update
    date_object = Date.strptime(params[:fecha], '%Y-%m-%d')
    created_at = Time.zone.parse("#{date_object.year}-#{date_object.month}-#{date_object.day} #{Time.now.hour}:#{Time.now.min}:#{Time.now.sec}")
    historial = HistorialUrgencia.create!(
      heridos_arma_fuego: params[:heridos_arma_fuego],
      heridos_arma_blanca: params[:heridos_arma_blanca],
      heridos_arma_contundente: params[:heridos_arma_contundente],
      heridos_accidente_transito: params[:heridos_accidente_transito],
      urgencias_totales_atendidas: params[:urgencias_totales_atendidas],
      pacientes_observacion: params[:pacientes_observacion],
      cirugias_urgencias: params[:cirugias_urgencias]
    )
    historial.institucion = Institucion.find_by_id params[:id]
    historial.usuario = current_usuario
    historial.created_at = created_at
    historial.save!
    flash[:notice] = "Urgencias de #{historial.institucion.nombre} actualizadas correctamente"
    redirect_to historial_urgencias_path
  end

  def destroy
  end
end
