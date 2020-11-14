class Crue::HistorialRecursoUrgenciasController < ApplicationController
  include NotificationManager
  require 'net/http'
  before_action :authenticate_usuario!

  def last_recurso
    institucion = Institucion.find_by_id params[:id]
    render json: institucion.historial_recurso_urgencias.last.to_json(methods: [:created_at_formatted])
  end

  def consulta
    totales = {
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

      HistorialRecursoUrgencia.where(institucion: institucion, created_at: @start_date_object..@end_date_object).each do |registro|
        parciales[:camas_adultos] += registro.camas_adultos || 0
        parciales[:camas_pediatricas] += registro.camas_pediatricas || 0
        parciales[:camas_salud_mental] += registro.camas_salud_mental || 0
        parciales[:camas_obstetricas] += registro.camas_obstetricas || 0
        parciales[:camas_reanimacion] += registro.camas_reanimacion || 0
        parciales[:camas_sala_de_procedimiento] += registro.camas_sala_de_procedimiento || 0
        parciales[:camas_o_sillas_salas_eda] += registro.camas_o_sillas_salas_eda || 0
        parciales[:camas_o_sillas_salas_era] += registro.camas_o_sillas_salas_era || 0
        parciales[:consultorios_atencion] += registro.consultorios_atencion || 0
        parciales[:consultorios_triage] += registro.consultorios_triage || 0
        parciales[:salas_de_yeso] += registro.salas_de_yeso || 0
        parciales[:total] += registro.total || 0
      end
      @historiales << {
        institucion: institucion,
        registro: parciales
      }
      totales[:camas_adultos] += parciales[:camas_adultos]
      totales[:camas_pediatricas] += parciales[:camas_pediatricas]
      totales[:camas_salud_mental] += parciales[:camas_salud_mental]
      totales[:camas_obstetricas] += parciales[:camas_obstetricas]
      totales[:camas_reanimacion] += parciales[:camas_reanimacion]
      totales[:camas_sala_de_procedimiento] += parciales[:camas_sala_de_procedimiento]
      totales[:camas_o_sillas_salas_eda] += parciales[:camas_o_sillas_salas_eda]
      totales[:camas_o_sillas_salas_era] += parciales[:camas_o_sillas_salas_era]
      totales[:consultorios_atencion] += parciales[:consultorios_atencion]
      totales[:consultorios_triage] += parciales[:consultorios_triage]
      totales[:salas_de_yeso] += parciales[:salas_de_yeso]
      totales[:total] += parciales[:total]
    end

    items = [
      { tag: 'Camas Adultos', value: totales[:camas_adultos] },
      { tag: 'Camas Pediatricas', value: totales[:camas_pediatricas] },
      { tag: 'Camas Salud Mental', value: totales[:camas_salud_mental] },
      { tag: 'Camas Obstetricas', value: totales[:camas_obstetricas] },
      { tag: 'Camas Reanimacion', value: totales[:camas_reanimacion] },
      { tag: 'Camas Sala de Procedimiento', value: totales[:camas_sala_de_procedimiento] },
      { tag: 'Camas o sillas salas EDA', value: totales[:camas_o_sillas_salas_eda] },
      { tag: 'Camas o sillas salas ERA', value: totales[:camas_o_sillas_salas_era] },
      { tag: 'Consultorios Atencion', value: totales[:consultorios_atencion] },
      { tag: 'Consultorios Triage', value: totales[:consultorios_triage] },
      { tag: 'Salas de Yeso', value: totales[:salas_de_yeso] },
      { tag: 'Total', value: totales[:total] }
    ]

    @json_historiales = Jbuilder.encode do |json|
      json.array! items do |item|
        json.set! :tag, item[:tag]
        json.set! :value, item[:value]
      end
    end

    items_historiales = [
      { tag: 'Camas Adultos', value: totales[:camas_adultos] },
      { tag: 'Camas Pediatricas', value: totales[:camas_pediatricas] },
      { tag: 'Camas Salud Mental', value: totales[:camas_salud_mental] },
      { tag: 'Camas Obstetricas', value: totales[:camas_obstetricas] },
      { tag: 'Camas Reanimacion', value: totales[:camas_reanimacion] },
      { tag: 'Camas Sala de Procedimiento', value: totales[:camas_sala_de_procedimiento] },
      { tag: 'Camas o sillas salas EDA', value: totales[:camas_o_sillas_salas_eda] },
      { tag: 'Camas o sillas salas ERA', value: totales[:camas_o_sillas_salas_era] },
      { tag: 'Consultorios Atencion', value: totales[:consultorios_atencion] },
      { tag: 'Consultorios Triage', value: totales[:consultorios_triage] },
      { tag: 'Salas de Yeso', value: totales[:salas_de_yeso] },
      { tag: 'Total', value: totales[:total] }
    ]

    @json_historiales = Jbuilder.encode do |json|
      json.array! items_historiales do |item|
        json.set! :tag, item[:tag]
        json.set! :value, item[:value]
      end
    end

    @historiales << { institucion: nil, registro: totales }
  end

  def do_consulta
    redirect_to "#{consulta_historial_recurso_urgencias_path}?start_date=#{params[:start_date].first}&end_date=#{params[:end_date].first}"
  end

  def index

    @datetime_object = !params[:datetime].nil? ? Time.strptime(params[:datetime], '%Y-%m-%dT%T') : Time.now
    @datetime = @datetime_object.strftime('%Y-%m-%dT%T')
    @instituciones = []
    Institucion.where(activo:true, municipio: current_municipio).sort_by(&:created_at).each do |institucion|
      @instituciones << institucion if institucion.roles_array.include?(ROLES_INSTITUCIONES[4])
    end
  end

  def change_date
    redirect_to "#{historial_recurso_urgencias_path}?datetime=#{params[:datetime]}"
  end

  def new
    @instituciones = []
    Institucion.where(activo:true, municipio: current_municipio).sort_by(&:created_at).each do |institucion|
      @instituciones << institucion if institucion.roles_array.include?(ROLES_INSTITUCIONES[4])
    end
  end

  def create
    params_ = params
    params_.delete(:commit)
    params_.delete(:id)
    params_.delete(:authenticity_token)
    params_.delete(:_method)
    params_.delete(:utf8)
    historial = HistorialRecursoUrgencia.create! params_
    historial.institucion = Institucion.find_by_id params[:ips]
    historial.usuario = current_usuario
    historial.save!
    flash[:notice] = "Recursos de #{historial.institucion.nombre} actualizados correctamente"
    redirect_to new_historial_recurso_urgencias_path
  end

  def search
    from_date = DateTime.strptime(params[:from_allhospitals_datetime], '%Y-%m-%d %H:%M')
    array_recursos = []

    url = URI.parse('http://ambulancias-api.herokuapp.com/get_hospitales/api_key=3C13E2961C4C1EE83D97BC2A76450')
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    @hospitales = JSON.parse res.body

    @historialrecursos = HistorialRecursoUrgencia.all(conditions: ['created_at >= ? AND created_at <= ?', from_date.beginning_of_day, from_date])
    unless @historialrecursos.empty?
      for hospital in @hospitales
        recursos = @historialrecursos.select { |h| h.hospital_id == hospital['id'] }
        recursos = recursos.sort_by &:created_at
        next if recursos.empty?
        last_recurso = recursos.last
        parsed_recurso = {}
        parsed_recurso[:camas_adultos] = last_recurso.camas_adultos
        parsed_recurso[:camas_pediatricas] = last_recurso.camas_pediatricas
        parsed_recurso[:camas_salud_mental] = last_recurso.camas_salud_mental
        parsed_recurso[:camas_obstetricas] = last_recurso.camas_obstetricas
        parsed_recurso[:camas_reanimacion] = last_recurso.camas_reanimacion
        parsed_recurso[:camas_sala_de_procedimiento] = last_recurso.camas_sala_de_procedimiento
        parsed_recurso[:camas_o_sillas_salas_eda] = last_recurso.camas_o_sillas_salas_eda
        parsed_recurso[:camas_o_sillas_salas_era] = last_recurso.camas_o_sillas_salas_era
        parsed_recurso[:consultorios_atencion] = last_recurso.consultorios_atencion
        parsed_recurso[:consultorios_triage] = last_recurso.consultorios_triage
        parsed_recurso[:salas_de_yeso] = last_recurso.salas_de_yeso
        parsed_recurso[:total] = last_recurso.total
        array_recursos.push parsed_recurso
      end
    end
    @historialrecursos = array_recursos.to_json
    render json: @historialrecursos
  end

  def edit
    @institucion = Institucion.find_by_id params[:id]
    @historial = HistorialRecursoUrgencia.where(institucion: @institucion).last
    render layout: false
  end

  def update
    @institucion = Institucion.find_by_id params[:id]
    historial = HistorialRecursoUrgencia.create!(
      estado_urgencia:(@institucion.estado_urgencia == 1 ? 2 : 1)
    )
    @institucion.estado_urgencia = historial.estado_urgencia
    @institucion.save!
    historial.institucion = @institucion
    historial.usuario = current_usuario
    historial.created_at = Time.now
    historial.save!
    flash[:notice] = "Recursos de urgencias #{historial.institucion.nombre} actualizados correctamente"
    redirect_to historial_recurso_urgencias_path
  end

  def destroy; end
end
