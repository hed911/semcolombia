class Crue::HistorialRecursosController < ApplicationController
  include NotificationManager
  require 'net/http'
  before_action :authenticate_user!

  def last_recurso
    institucion = Institucion.find_by_id params[:id]
    render json: institucion.historial_recursos.last.to_json(methods: [:created_at_formatted])
  end

  def consulta
    totales = {
      sueros_antiofilicos: 0,
      sangres_ab_positivo: 0,
      sangres_ab_negativo: 0,
      sangres_b_positivo: 0,
      sangres_b_negativo: 0,
      sangres_o_positivo: 0,
      sangres_o_negativo: 0,
      sangres_a_positivo: 0,
      sangres_a_negativo: 0,
      total_sangres: 0,
      adultos: 0,
      cuidado_agudo_mental: 0,
      cuidado_basico_neonatal: 0,
      cuidado_intensivo_adulto: 0,
      cuidado_intensivo_neonatal: 0,
      cuidado_intensivo_pediatrico: 0,
      cuidado_intermedio_adulto: 0,
      cuidado_intermedio_mental: 0,
      cuidado_intermedio_neonatal: 0,
      cuidado_intermedio_pediatrico: 0,
      farmacodependencia: 0,
      institucion_paciente_cronico: 0,
      obstetricia: 0,
      pediatrica: 0,
      psiquiatrica: 0,
      salud_mental: 0,
      transplante_de_progenitores_hematopoyeticos: 0,
      total_camas: 0
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
      parciales[:sueros_antiofilicos] = 0
      parciales[:sangres_ab_positivo] = 0
      parciales[:sangres_ab_negativo] = 0
      parciales[:sangres_b_positivo] = 0
      parciales[:sangres_b_negativo] = 0
      parciales[:sangres_o_positivo] = 0
      parciales[:sangres_o_negativo] = 0
      parciales[:sangres_a_positivo] = 0
      parciales[:sangres_a_negativo] = 0
      parciales[:total_sangres] = 0
      parciales[:adultos] = 0
      parciales[:cuidado_agudo_mental] = 0
      parciales[:cuidado_basico_neonatal] = 0
      parciales[:cuidado_intensivo_adulto] = 0
      parciales[:cuidado_intensivo_neonatal] = 0
      parciales[:cuidado_intensivo_pediatrico] = 0
      parciales[:cuidado_intermedio_adulto] = 0
      parciales[:cuidado_intermedio_mental] = 0
      parciales[:cuidado_intermedio_neonatal] = 0
      parciales[:cuidado_intermedio_pediatrico] = 0
      parciales[:farmacodependencia] = 0
      parciales[:institucion_paciente_cronico] = 0
      parciales[:obstetricia] = 0
      parciales[:pediatrica] = 0
      parciales[:psiquiatrica] = 0
      parciales[:salud_mental] = 0
      parciales[:transplante_de_progenitores_hematopoyeticos] = 0
      parciales[:total_camas] = 0

      HistorialRecurso.where(institucion: institucion, created_at: @start_date_object..@end_date_object).each do |registro|
        parciales[:sueros_antiofilicos] += registro.sueros_antiofilicos || 0
        parciales[:sangres_ab_positivo] += registro.sangres_ab_positivo || 0
        parciales[:sangres_ab_negativo] += registro.sangres_ab_negativo || 0
        parciales[:sangres_b_positivo] += registro.sangres_b_positivo || 0
        parciales[:sangres_b_negativo] += registro.sangres_b_negativo || 0
        parciales[:sangres_o_positivo] += registro.sangres_o_positivo || 0
        parciales[:sangres_o_negativo] += registro.sangres_o_negativo || 0
        parciales[:sangres_a_positivo] += registro.sangres_a_positivo || 0
        parciales[:sangres_a_negativo] += registro.sangres_a_negativo || 0
        parciales[:total_sangres] += registro.total_sangres || 0
        parciales[:adultos] += registro.adultos || 0
        parciales[:cuidado_agudo_mental] += registro.cuidado_agudo_mental || 0
        parciales[:cuidado_basico_neonatal] += registro.cuidado_basico_neonatal || 0
        parciales[:cuidado_intensivo_adulto] += registro.cuidado_intensivo_adulto || 0
        parciales[:cuidado_intensivo_neonatal] += registro.cuidado_intensivo_neonatal || 0
        parciales[:cuidado_intensivo_pediatrico] += registro.cuidado_intensivo_pediatrico || 0
        parciales[:cuidado_intermedio_adulto] += registro.cuidado_intermedio_adulto || 0
        parciales[:cuidado_intermedio_mental] += registro.cuidado_intermedio_mental || 0
        parciales[:cuidado_intermedio_neonatal] += registro.cuidado_intermedio_neonatal || 0
        parciales[:cuidado_intermedio_pediatrico] += registro.cuidado_intermedio_pediatrico || 0
        parciales[:farmacodependencia] += registro.farmacodependencia || 0
        parciales[:institucion_paciente_cronico] += registro.institucion_paciente_cronico || 0
        parciales[:obstetricia] += registro.obstetricia || 0
        parciales[:pediatrica] += registro.pediatrica || 0
        parciales[:psiquiatrica] += registro.psiquiatrica || 0
        parciales[:salud_mental] += registro.salud_mental || 0
        parciales[:transplante_de_progenitores_hematopoyeticos] += registro.transplante_de_progenitores_hematopoyeticos || 0
        parciales[:total_camas] += registro.total_camas || 0
      end
      @historiales << {
        institucion: institucion,
        registro: parciales
      }
      totales[:sueros_antiofilicos] += parciales[:sueros_antiofilicos]
      totales[:sangres_ab_positivo] += parciales[:sangres_ab_positivo]
      totales[:sangres_ab_negativo] += parciales[:sangres_ab_negativo]
      totales[:sangres_b_positivo] += parciales[:sangres_b_positivo]
      totales[:sangres_b_negativo] += parciales[:sangres_b_negativo]
      totales[:sangres_o_positivo] += parciales[:sangres_o_positivo]
      totales[:sangres_o_negativo] += parciales[:sangres_o_negativo]
      totales[:sangres_a_positivo] += parciales[:sangres_a_positivo]
      totales[:sangres_a_negativo] += parciales[:sangres_a_negativo]
      totales[:total_sangres] += parciales[:total_sangres]
      totales[:adultos] += parciales[:adultos]
      totales[:cuidado_agudo_mental] += parciales[:cuidado_agudo_mental]
      totales[:cuidado_basico_neonatal] += parciales[:cuidado_basico_neonatal]
      totales[:cuidado_intensivo_adulto] += parciales[:cuidado_intensivo_adulto]
      totales[:cuidado_intensivo_neonatal] += parciales[:cuidado_intensivo_neonatal]
      totales[:cuidado_intensivo_pediatrico] += parciales[:cuidado_intensivo_pediatrico]
      totales[:cuidado_intermedio_adulto] += parciales[:cuidado_intermedio_adulto]
      totales[:cuidado_intermedio_mental] += parciales[:cuidado_intermedio_mental]
      totales[:cuidado_intermedio_neonatal] += parciales[:cuidado_intermedio_neonatal]
      totales[:cuidado_intermedio_pediatrico] += parciales[:cuidado_intermedio_pediatrico]
      totales[:farmacodependencia] += parciales[:farmacodependencia]
      totales[:institucion_paciente_cronico] += parciales[:institucion_paciente_cronico]
      totales[:obstetricia] += parciales[:obstetricia]
      totales[:pediatrica] += parciales[:pediatrica]
      totales[:psiquiatrica] += parciales[:psiquiatrica]
      totales[:salud_mental] += parciales[:salud_mental]
      totales[:transplante_de_progenitores_hematopoyeticos] += parciales[:transplante_de_progenitores_hematopoyeticos]
      totales[:total_camas] += parciales[:total_camas]
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


    items_historiales_sangres = [
      { tag: 'S. Antiofidicos', value: totales[:sueros_antiofilicos] },
      { tag: 'AB+', value: totales[:sangres_ab_positivo] },
      { tag: 'AB-', value: totales[:sangres_ab_negativo] },
      { tag: 'B+', value: totales[:sangres_b_positivo] },
      { tag: 'B-', value: totales[:sangres_b_negativo] },
      { tag: 'O+', value: totales[:sangres_o_positivo] },
      { tag: 'O-', value: totales[:sangres_o_negativo] },
      { tag: 'A+', value: totales[:sangres_a_positivo] },
      { tag: 'A-', value: totales[:sangres_a_negativo] }
    ]

    items_historiales_camas = [
      { tag: 'Adultos', value: totales[:adultos] },
      { tag: 'Cuidado agudo mental', value: totales[:cuidado_agudo_mental] },
      { tag: 'Cuidado basico neonatal', value: totales[:cuidado_basico_neonatal] },
      { tag: 'Cuidado intensivo adulto', value: totales[:cuidado_intensivo_adulto] },
      { tag: 'Cuidado intensivo neonatal', value: totales[:cuidado_intensivo_neonatal] },
      { tag: 'Cuidado intensivo pediatrico', value: totales[:cuidado_intensivo_pediatrico] },
      { tag: 'Cuidado intermedio adulto', value: totales[:cuidado_intermedio_adulto] },
      { tag: 'Cuidado intermedio mental', value: totales[:cuidado_intermedio_mental] },
      { tag: 'Cuidado intermedio neonatal', value: totales[:cuidado_intermedio_neonatal] },
      { tag: 'Cuidado intermedio pediatrico', value: totales[:cuidado_intermedio_pediatrico] },
      { tag: 'Farmacodependencia', value: totales[:farmacodependencia] },
      { tag: 'Institucion paciente cronico', value: totales[:institucion_paciente_cronico] },
      { tag: 'Obstetricia', value: totales[:obstetricia] },
      { tag: 'Pediatrica', value: totales[:pediatrica] },
      { tag: 'Psiquiatrica', value: totales[:psiquiatrica] },
      { tag: 'Salud mental', value: totales[:salud_mental] },
      { tag: 'Transplante de progenitores hematopoyeticos', value: totales[:transplante_de_progenitores_hematopoyeticos] },
    ]

    @json_historiales_sangres = Jbuilder.encode do |json|
      json.array! items_historiales_camas do |item|
        json.set! :tag, item[:tag]
        json.set! :value, item[:value]
      end
    end
    @json_historiales_camas = Jbuilder.encode do |json|
      json.array! items_historiales_sangres do |item|
        json.set! :tag, item[:tag]
        json.set! :value, item[:value]
      end
    end

    @historiales << { institucion: nil, registro: totales }
  end

  def do_consulta
    redirect_to "#{consulta_historial_recursos_path}?start_date=#{params[:start_date].first}&end_date=#{params[:end_date].first}"
  end

  def index
    totales = {
      sueros_antiofilicos: 0,
      sangres_ab_positivo: 0,
      sangres_ab_negativo: 0,
      sangres_b_positivo: 0,
      sangres_b_negativo: 0,
      sangres_o_positivo: 0,
      sangres_o_negativo: 0,
      sangres_a_positivo: 0,
      sangres_a_negativo: 0,
      total_sangres: 0,
      adultos: 0,
      cuidado_agudo_mental: 0,
      cuidado_basico_neonatal: 0,
      cuidado_intensivo_adulto: 0,
      cuidado_intensivo_neonatal: 0,
      cuidado_intensivo_pediatrico: 0,
      cuidado_intermedio_adulto: 0,
      cuidado_intermedio_mental: 0,
      cuidado_intermedio_neonatal: 0,
      cuidado_intermedio_pediatrico: 0,
      farmacodependencia: 0,
      institucion_paciente_cronico: 0,
      obstetricia: 0,
      pediatrica: 0,
      psiquiatrica: 0,
      salud_mental: 0,
      transplante_de_progenitores_hematopoyeticos: 0,
      total_camas: 0
    }
    @datetime_object = !params[:datetime].nil? ? Time.strptime(params[:datetime], '%Y-%m-%dT%T') : Time.now
    @datetime = @datetime_object.strftime('%Y-%m-%dT%T')
    @historiales = []
    Institucion.where(activo:true, municipio: current_municipio).order('created_at ASC').each do |institucion|
      next unless institucion.roles_array.include?(ROLES_INSTITUCIONES[4])
      registro = HistorialRecurso.where(institucion: institucion).where('created_at < ?', @datetime_object).last
      @historiales << {
        institucion: institucion,
        registro: registro
      }
      puts "REGISTRO NULL: #{institucion.nombre}" if registro.nil?
      next unless registro
      next unless registro
      totales[:sueros_antiofilicos] += registro.sueros_antiofilicos || 0
      totales[:sangres_ab_positivo] += registro.sangres_ab_positivo || 0
      totales[:sangres_ab_negativo] += registro.sangres_ab_negativo || 0
      totales[:sangres_b_positivo] += registro.sangres_b_positivo || 0
      totales[:sangres_b_negativo] += registro.sangres_b_negativo || 0
      totales[:sangres_o_positivo] += registro.sangres_o_positivo || 0
      totales[:sangres_o_negativo] += registro.sangres_o_negativo || 0
      totales[:sangres_a_positivo] += registro.sangres_a_positivo || 0
      totales[:sangres_a_negativo] += registro.sangres_a_negativo || 0
      totales[:total_sangres] += registro.total_sangres || 0
      totales[:adultos] += registro.adultos || 0
      totales[:cuidado_agudo_mental] += registro.cuidado_agudo_mental || 0
      totales[:cuidado_basico_neonatal] += registro.cuidado_basico_neonatal || 0
      totales[:cuidado_intensivo_adulto] += registro.cuidado_intensivo_adulto || 0
      totales[:cuidado_intensivo_neonatal] += registro.cuidado_intensivo_neonatal || 0
      totales[:cuidado_intensivo_pediatrico] += registro.cuidado_intensivo_pediatrico || 0
      totales[:cuidado_intermedio_adulto] += registro.cuidado_intermedio_adulto || 0
      totales[:cuidado_intermedio_mental] += registro.cuidado_intermedio_mental || 0
      totales[:cuidado_intermedio_neonatal] += registro.cuidado_intermedio_neonatal || 0
      totales[:cuidado_intermedio_pediatrico] += registro.cuidado_intermedio_pediatrico || 0
      totales[:farmacodependencia] += registro.farmacodependencia || 0
      totales[:institucion_paciente_cronico] += registro.institucion_paciente_cronico || 0
      totales[:obstetricia] += registro.obstetricia || 0
      totales[:pediatrica] += registro.pediatrica || 0
      totales[:psiquiatrica] += registro.psiquiatrica || 0
      totales[:salud_mental] += registro.salud_mental || 0
      totales[:transplante_de_progenitores_hematopoyeticos] += registro.transplante_de_progenitores_hematopoyeticos || 0
      totales[:total_camas] += registro.total_camas || 0
    end

    @historiales.sort! { |a, b| a[:registro] && b[:registro] ? a[:registro].created_at <=> b[:registro].created_at : a[:registro] ? -1 : 1 }
    @historiales.reverse!
    @historiales << { institucion: nil, registro: totales }

    items_historiales_sangres = [
      { tag: 'S. Antiofidicos', value: totales[:sueros_antiofilicos] },
      { tag: 'AB+', value: totales[:sangres_ab_positivo] },
      { tag: 'AB-', value: totales[:sangres_ab_negativo] },
      { tag: 'B+', value: totales[:sangres_b_positivo] },
      { tag: 'B-', value: totales[:sangres_b_negativo] },
      { tag: 'O+', value: totales[:sangres_o_positivo] },
      { tag: 'O-', value: totales[:sangres_o_negativo] },
      { tag: 'A+', value: totales[:sangres_a_positivo] },
      { tag: 'A-', value: totales[:sangres_a_negativo] }
    ]

    items_historiales_camas = [
      { tag: 'Adultos', value: totales[:adultos] },
      { tag: 'Cuidado agudo mental', value: totales[:cuidado_agudo_mental] },
      { tag: 'Cuidado basico neonatal', value: totales[:cuidado_basico_neonatal] },
      { tag: 'Cuidado intensivo adulto', value: totales[:cuidado_intensivo_adulto] },
      { tag: 'Cuidado intensivo neonatal', value: totales[:cuidado_intensivo_neonatal] },
      { tag: 'Cuidado intensivo pediatrico', value: totales[:cuidado_intensivo_pediatrico] },
      { tag: 'Cuidado intermedio adulto', value: totales[:cuidado_intermedio_adulto] },
      { tag: 'Cuidado intermedio mental', value: totales[:cuidado_intermedio_mental] },
      { tag: 'Cuidado intermedio neonatal', value: totales[:cuidado_intermedio_neonatal] },
      { tag: 'Cuidado intermedio pediatrico', value: totales[:cuidado_intermedio_pediatrico] },
      { tag: 'Farmacodependencia', value: totales[:farmacodependencia] },
      { tag: 'Institucion paciente cronico', value: totales[:institucion_paciente_cronico] },
      { tag: 'Obstetricia', value: totales[:obstetricia] },
      { tag: 'Pediatrica', value: totales[:pediatrica] },
      { tag: 'Psiquiatrica', value: totales[:psiquiatrica] },
      { tag: 'Salud mental', value: totales[:salud_mental] },
      { tag: 'Transplante de progenitores hematopoyeticos', value: totales[:transplante_de_progenitores_hematopoyeticos] },
    ]

    @json_historiales_sangres = Jbuilder.encode do |json|
      json.array! items_historiales_camas do |item|
        json.set! :tag, item[:tag]
        json.set! :value, item[:value]
      end
    end
    @json_historiales_camas = Jbuilder.encode do |json|
      json.array! items_historiales_sangres do |item|
        json.set! :tag, item[:tag]
        json.set! :value, item[:value]
      end
    end
    @historiales << { institucion: nil, registro: totales }
    # raise "tipo:#{@json_historiales_sangres}"
  end

  def change_date
    redirect_to "#{historial_recursos_path}?datetime=#{params[:datetime]}"
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
    historial = HistorialRecurso.create! params_
    historial.institucion = Institucion.find_by_id params[:ips]
    historial.usuario = current_usuario
    historial.save!
    flash[:notice] = "Recursos de #{historial.institucion.nombre} actualizados correctamente"
    redirect_to new_historial_recurso_path
  end

  def edit
    @institucion = Institucion.find_by_id params[:id]
    @historial = HistorialRecurso.where(institucion: @institucion).last
    render layout: false
  end

  def update
    historial = HistorialRecurso.create!(
      sueros_antiofilicos: params[:sueros_antiofilicos],
      sangres_ab_positivo: params[:sangres_ab_positivo],
      sangres_ab_negativo: params[:sangres_ab_negativo],
      sangres_b_positivo: params[:sangres_b_positivo],
      sangres_b_negativo: params[:sangres_b_negativo],
      sangres_o_positivo: params[:sangres_o_positivo],
      sangres_o_negativo: params[:sangres_o_negativo],
      sangres_a_positivo: params[:sangres_a_positivo],
      sangres_a_negativo: params[:sangres_a_negativo],
      adultos: params[:adultos],
      cuidado_agudo_mental: params[:cuidado_agudo_mental],
      cuidado_basico_neonatal: params[:cuidado_basico_neonatal],
      cuidado_intensivo_adulto: params[:cuidado_intensivo_adulto],
      cuidado_intensivo_neonatal: params[:cuidado_intensivo_neonatal],
      cuidado_intensivo_pediatrico: params[:cuidado_intensivo_pediatrico],
      cuidado_intermedio_adulto: params[:cuidado_intermedio_adulto],
      cuidado_intermedio_mental: params[:cuidado_intermedio_mental],
      cuidado_intermedio_neonatal: params[:cuidado_intermedio_neonatal],
      cuidado_intermedio_pediatrico: params[:cuidado_intermedio_pediatrico],
      farmacodependencia: params[:farmacodependencia],
      institucion_paciente_cronico: params[:institucion_paciente_cronico],
      obstetricia: params[:obstetricia],
      pediatrica: params[:pediatrica],
      psiquiatrica: params[:psiquiatrica],
      salud_mental: params[:salud_mental],
      transplante_de_progenitores_hematopoyeticos: params[:transplante_de_progenitores_hematopoyeticos]
    )
    historial.institucion = Institucion.find_by_id params[:id]
    historial.usuario = current_usuario
    historial.created_at = Time.now
    historial.save!
    flash[:notice] = "Recursos de #{historial.institucion.nombre} actualizados correctamente"
    redirect_to historial_recursos_path
  end

  def destroy; end
end
