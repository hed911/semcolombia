class DashboardController < ApplicationController
  require 'net/http'
  before_action :authenticate_usuario!, except:[:cosa_ssl, :consulta, :do_consulta, :consulta_barranquilla, :consulta_soledad, :do_consulta_soledad, :do_consulta_barranquilla, :consulta_cartagena, :do_consulta_cartagena, :consulta_monteria, :do_consulta_monteria, :consulta_atlantico, :do_consulta_atlantico]

  def index
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def dashboard_por_ips
    template_items = {
      total_general:0
    }
    @columns = {}
    @registros_ = [
      {
        text: "SIN IPS",
        tag: "0",
        items:template_items.clone
      }
    ]
    Institucion.where(activo:true, municipio:Municipio.find(MUNICIPIO_PROYECTO_ID)).each do |institucion|
      next unless institucion.roles_array.include?(ROLES_INSTITUCIONES[3])
      @registros_ << {
        text: institucion.nombre,
        tag: "#{institucion.id}",
        items:template_items.clone
      }
    end
    @totales = template_items.clone
    hash = {}
    hash[:created_at] = (Date.strptime(params[:start_date], '%Y-%m-%d').beginning_of_day..Date.strptime(params[:end_date], '%Y-%m-%d').end_of_day) if params[:start_date] && params[:start_date] != '' && params[:end_date] && params[:end_date] != ''
    EventoAmbulatorio.where(hash).each do |registro|
      current_registro = @registros_.select { |r| (registro.institucion && r[:tag] == registro.institucion.id.to_s) || (registro.institucion.nil? && r[:tag] == "0") }.first
      next if current_registro.nil?
      current_registro[:items][:cumplido_pendiente] = 0 if current_registro[:items][:cumplido_pendiente].nil?
      current_registro[:items][:cumplido_pendiente] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_PENDIENTE && registro.estado == 5

      current_registro[:items][:cumplido_aprobado] = 0 if current_registro[:items][:cumplido_aprobado].nil?
      current_registro[:items][:cumplido_aprobado] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_APROBADO

      current_registro[:items][:cumplido_denegado] = 0 if current_registro[:items][:cumplido_denegado].nil?
      current_registro[:items][:cumplido_denegado] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_DENEGADO

      current_registro[:items][:otro] = 0 if current_registro[:items][:otro].nil?
      current_registro[:items][:otro] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_PENDIENTE && registro.estado != 5

      current_registro[:items][:total_general] = 0 if current_registro[:items][:total_general].nil?
      current_registro[:items][:total_general] += 1

      @totales[:cumplido_pendiente] = 0 if @totales[:cumplido_pendiente].nil?
      @totales[:cumplido_pendiente] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_PENDIENTE && registro.estado == 5

      @totales[:cumplido_aprobado] = 0 if @totales[:cumplido_aprobado].nil?
      @totales[:cumplido_aprobado] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_APROBADO

      @totales[:cumplido_denegado] = 0 if @totales[:cumplido_denegado].nil?
      @totales[:cumplido_denegado] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_DENEGADO

      @totales[:otro] = 0 if @totales[:otro].nil?
      @totales[:otro] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_PENDIENTE && registro.estado != 5

      @totales[:total_general] += 1
      @columns[:cumplido_pendiente] = "CUMPLIDO PENDIENTE"
      @columns[:cumplido_aprobado] = "CUMPLIDO APROBADO"
      @columns[:cumplido_denegado] = "CUMPLIDO DENEGADO"
      @columns[:otro] = "OTROS"
    end
    @registros = []
    @registros_.each do |registro|
      @registros << registro unless registro[:items][:total_general].zero?
    end
    render layout:false
  end

  def dashboard_por_ambulancia
    template_items = {
      total_general:0
    }
    @columns = {}
    @registros_ = [
      {
        text: "SIN AMBULANCIA",
        tag: "0",
        items:template_items.clone
      }
    ]
    Ambulancia.where(municipio:Municipio.find(MUNICIPIO_PROYECTO_ID)).each do |ambulancia|
      @registros_ << {
        text: "#{ambulancia.placa.upcase} (#{ambulancia.empresa_ambulancia.nombre if ambulancia.empresa_ambulancia})",
        tag: "#{ambulancia.id}",
        items:template_items.clone
      }
    end
    @totales = template_items.clone
    hash = {}
    hash[:created_at] = (Date.strptime(params[:start_date], '%Y-%m-%d').beginning_of_day..Date.strptime(params[:end_date], '%Y-%m-%d').end_of_day) if params[:start_date] && params[:start_date] != '' && params[:end_date] && params[:end_date] != ''
    EventoAmbulatorio.where(hash).each do |registro|
      current_registro = @registros_.select { |r| (registro.ambulancia && r[:tag] == registro.ambulancia.id.to_s) || (registro.ambulancia.nil? && r[:tag] == "0") }.first
      next if current_registro.nil?
      current_registro[:items][:cumplido_pendiente] = 0 if current_registro[:items][:cumplido_pendiente].nil?
      current_registro[:items][:cumplido_pendiente] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_PENDIENTE && registro.estado == 5

      current_registro[:items][:cumplido_aprobado] = 0 if current_registro[:items][:cumplido_aprobado].nil?
      current_registro[:items][:cumplido_aprobado] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_APROBADO

      current_registro[:items][:cumplido_denegado] = 0 if current_registro[:items][:cumplido_denegado].nil?
      current_registro[:items][:cumplido_denegado] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_DENEGADO

      current_registro[:items][:otro] = 0 if current_registro[:items][:otro].nil?
      current_registro[:items][:otro] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_PENDIENTE && registro.estado != 5

      current_registro[:items][:total_general] = 0 if current_registro[:items][:total_general].nil?
      current_registro[:items][:total_general] += 1

      @totales[:cumplido_pendiente] = 0 if @totales[:cumplido_pendiente].nil?
      @totales[:cumplido_pendiente] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_PENDIENTE && registro.estado == 5

      @totales[:cumplido_aprobado] = 0 if @totales[:cumplido_aprobado].nil?
      @totales[:cumplido_aprobado] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_APROBADO

      @totales[:cumplido_denegado] = 0 if @totales[:cumplido_denegado].nil?
      @totales[:cumplido_denegado] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_DENEGADO

      @totales[:otro] = 0 if @totales[:otro].nil?
      @totales[:otro] += 1 if registro.estado_cumplimiento == CUMPLIMIENTO_PENDIENTE && registro.estado != 5

      @totales[:total_general] += 1
      @columns[:cumplido_pendiente] = "CUMPLIDO PENDIENTE"
      @columns[:cumplido_aprobado] = "CUMPLIDO APROBADO"
      @columns[:cumplido_denegado] = "CUMPLIDO DENEGADO"
      @columns[:otro] = "OTROS"
    end
    @registros = []
    @registros_.each do |registro|
      @registros << registro unless registro[:items][:total_general].zero?
    end
    render layout:false
  end

  def dashboard_por_tipo
    template_items = {
      total_general:0
    }
    @columns = {}
    @registros_ = [
      {
        text: "SIN IPS",
        tag: "0",
        items:template_items.clone
      }
    ]
    Institucion.where(activo:true, municipio:Municipio.find(MUNICIPIO_PROYECTO_ID)).each do |institucion|
      #next unless institucion.roles_array.include?(ROLES_INSTITUCIONES[3])
      @registros_ << {
        text: institucion.nombre,
        tag: "#{institucion.id}",
        items:template_items.clone
      }
    end
    @totales = template_items.clone
    hash = {}
    hash[:created_at] = (Date.strptime(params[:start_date], '%Y-%m-%d').beginning_of_day..Date.strptime(params[:end_date], '%Y-%m-%d').end_of_day) if params[:start_date] && params[:start_date] != '' && params[:end_date] && params[:end_date] != ''

    Ingreso.where(hash).each do |registro|
      current_registro = @registros_.select { |r| (registro.institucion && r[:tag] == registro.institucion.id.to_s) || (registro.institucion.nil? && r[:tag] == "0") }.first
      next if current_registro.nil?
      current_registro[:items][registro.tipo] = 0 if current_registro[:items][registro.tipo].nil?
      current_registro[:items][registro.tipo] += 1

      current_registro[:items][:total_general] = 0 if current_registro[:items][:total_general].nil?
      current_registro[:items][:total_general] += 1

      @totales[registro.tipo] = 0 if @totales[registro.tipo].nil?
      @totales[registro.tipo] += 1

      @totales[:total_general] += 1
      @columns[TIPO_INGRESO_AMBULANCIA] = "AMBULANCIA"
      @columns[TIPO_INGRESO_EXTERNO] = "EXTERNO"
      @columns[TIPO_INGRESO_PPNA] = "PPNA"
    end
    @registros = []
    @registros_.each do |registro|
      @registros << registro unless registro[:items][:total_general].zero?
    end
    render layout:false
  end


  def dashboard_por_ips_ambulancia
    template_items = {
      total_general:0
    }
    @columns = {}
    @registros_ = [
      {
        text: "SIN IPS",
        tag: "0",
        items:template_items.clone
      }
    ]
    Institucion.where(activo:true, municipio:Municipio.find(MUNICIPIO_PROYECTO_ID)).each do |institucion|
      #next unless institucion.roles_array.include?(ROLES_INSTITUCIONES[3])
      @registros_ << {
        text: institucion.nombre,
        tag: "#{institucion.id}",
        items:template_items.clone
      }
    end
    @totales = template_items.clone
    hash = {}
    hash[:created_at] = (Date.strptime(params[:start_date], '%Y-%m-%d').beginning_of_day..Date.strptime(params[:end_date], '%Y-%m-%d').end_of_day) if params[:start_date] && params[:start_date] != '' && params[:end_date] && params[:end_date] != ''
    EventoAmbulatorio.where(hash).each do |registro|
      current_registro = @registros_.select { |r| (registro.institucion && r[:tag] == registro.institucion.id.to_s) || (registro.institucion.nil? && r[:tag] == "0") }.first
      next if current_registro.nil?
      current_registro[:items][registro.ambulancia.id] = 0 if current_registro[:items][registro.ambulancia.id].nil?
      current_registro[:items][registro.ambulancia.id] += 1

      current_registro[:items][:total_general] = 0 if current_registro[:items][:total_general].nil?
      current_registro[:items][:total_general] += 1

      @totales[registro.ambulancia.id] = 0 if @totales[registro.ambulancia.id].nil?
      @totales[registro.ambulancia.id] += 1

      @totales[:total_general] += 1
      @columns[registro.ambulancia.id] = registro.ambulancia.placa.upcase if registro.ambulancia.placa
    end
    @registros = []
    @registros_.each do |registro|
      @registros << registro unless registro[:items][:total_general].zero?
    end
    render layout:false
  end

  def dashboard_por_ips_categoria_evento
    template_items = {
      total_general:0
    }
    @columns = {}
    @registros_ = [
      {
        text: "SIN IPS",
        tag: "0",
        items:template_items.clone
      }
    ]
    Institucion.where(activo:true, municipio:Municipio.find(MUNICIPIO_PROYECTO_ID)).each do |institucion|
      #next unless institucion.roles_array.include?(ROLES_INSTITUCIONES[3])
      @registros_ << {
        text: institucion.nombre,
        tag: "#{institucion.id}",
        items:template_items.clone
      }
    end
    @totales = template_items.clone
    hash = {}
    hash[:created_at] = (Date.strptime(params[:start_date], '%Y-%m-%d').beginning_of_day..Date.strptime(params[:end_date], '%Y-%m-%d').end_of_day) if params[:start_date] && params[:start_date] != '' && params[:end_date] && params[:end_date] != ''

    Ingreso.where(hash).where.not(evento_ambulatorio:nil).each do |registro|
      current_registro = @registros_.select { |r| (registro.evento_ambulatorio.categoria_evento && r[:tag] == registro.evento_ambulatorio.categoria_evento.id.to_s) || (registro.evento_ambulatorio && registro.evento_ambulatorio.categoria_evento.nil? && r[:tag] == "0") }.first
      next if current_registro.nil?
      puts "SI HAY REGISTROS VE"
      categoria_id = registro.evento_ambulatorio.categoria_evento ? registro.evento_ambulatorio.categoria_evento.id : 0
      current_registro[:items][categoria_id] = 0 if current_registro[:items][categoria_id].nil?
      current_registro[:items][categoria_id] += 1

      current_registro[:items][:total_general] = 0 if current_registro[:items][:total_general].nil?
      current_registro[:items][:total_general] += 1

      @totales[categoria_id] = 0 if @totales[categoria_id].nil?
      @totales[categoria_id] += 1

      @totales[:total_general] += 1
      @columns[categoria_id] = registro.evento_ambulatorio.categoria_evento ? registro.evento_ambulatorio.categoria_evento.nombre.upcase : "SIN IPS"
    end
    puts "YA TERMINE"
    @registros = []
    @registros_.each do |registro|
      @registros << registro unless registro[:items][:total_general].zero?
    end
    render layout:false
  end

  def ambulancias
    @cantidad_total = Ambulancia.where(habilitada:true, municipio:current_municipio).count
    @ambulancias_en_transito = []
    @ambulancias_no_disponibles = []
    @ambulancias_disponibles = []
    @ambulancias_deshabilitadas = []
    @ambulancias_desconectadas = []
    @ambulancias = Ambulancia.where(municipio:current_municipio)
    @ambulancias.each do |ambulancia|
      resumen_estado = ambulancia.resumen_estado
      if !ambulancia.habilitada
        @ambulancias_deshabilitadas << ambulancia
        next
      end
      @ambulancias_en_transito << ambulancia if resumen_estado[:en_transito]
      @ambulancias_no_disponibles << ambulancia if !resumen_estado[:en_transito] && !ambulancia.disponible
      @ambulancias_desconectadas << ambulancia if !resumen_estado[:variables][:ping_reciente] || !resumen_estado[:variables][:ubicacion_reciente]
      @ambulancias_disponibles << ambulancia if resumen_estado[:puede_recibir_casos]
    end
  end

  def profile; end

  def dashboard_conexiones

  end

  def set_institucion
    session[:institucion_id] = params[:id]
    redirect_back fallback_location: root_path
  end

  def notifications_panel
    @notificaciones = NotificacionEmergente.where(usuario:current_usuario, municipio:current_municipio).order("created_at DESC")
    render layout:false
  end

  def mark_as_read
    NotificacionEmergente.where(usuario:current_usuario, municipio:current_municipio).each do |notificacion|
      notificacion.estado = 2
      notificacion.save!
    end
    render json:{}.to_json
  end

  def consulta
    @muestras = []
  end

  def do_consulta
    if verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentar"
      @muestras = []
    end
    render 'consulta'
  end

  def consulta_barranquilla
    @muestras = []
  end

  def do_consulta_barranquilla
    if verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.municipio_id'] = [4, 1988]
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        #hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentar"
      @muestras = []
    end
    render 'consulta_barranquilla'
  end

  def consulta_soledad
    @muestras = []
  end

  def do_consulta_soledad
    if verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.municipio_id'] = 22
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentar"
      @muestras = []
    end
    render 'consulta_soledad'
  end

  def consulta_cartagena
    @muestras = []
  end

  def do_consulta_cartagena
    if verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.municipio_id'] = 27
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentar"
      @muestras = []
    end
    render 'consulta_cartagena'
  end

  def consulta_monteria
    @muestras = []
  end

  def do_consulta_monteria
    if verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.municipio_id'] = 1427
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentar"
      @muestras = []
    end
    render 'consulta_monteria'
  end

  def consulta_atlantico
    @muestras = []
  end

  def do_consulta_atlantico
    if Rails.env.development? || verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.municipio_id'] = [4, 1988]
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash = {}
        start_date = DateTime.strptime("#{params[:mes]}-01",'%Y-%m-%d') if !params[:mes].nil? && !params[:mes].empty?
        end_date = start_date.end_of_month if !params[:mes].nil? && !params[:mes].empty?
        hash[:fecha] = start_date..end_date if !params[:mes].nil? && !params[:mes].empty?
        #hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where(hash).where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
        @muestras = @muestras.uniq{|m| m.fecha_realizacion}
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentaro"
      @muestras = []
    end
    render 'consulta_atlantico'
  end

end

