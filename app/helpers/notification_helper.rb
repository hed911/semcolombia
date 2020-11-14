module NotificationHelper

  def self.notificar_email(evento_, hospital_users)
    emails = hospital_users.select{ |h| h.envio_correo }.map { |h| h.email }
    return if emails.empty?
    RemisionMailer.new_evento_ambulatorio(
      evento_,
      emails
    ).deliver
  end

  def self.notificar_sms_paciente_en_camino(evento)
    return if evento.institucion.nil?
    empresa_ambulancia_users = evento.ambulancia && evento.ambulancia.empresa_ambulancia ? evento.ambulancia.empresa_ambulancia.virtual_users : []
    (evento.institucion.hospital_users.to_a + evento.institucion.virtual_users + empresa_ambulancia_users).each do |hospital_user|
      self.notificar_sms(evento, hospital_user)
    end
  end

  def self.notificar_sms(evento, hospital_user)
    return unless hospital_user.envio_correo && hospital_user.telefono && hospital_user.telefono.length == 10
    placa = evento.ambulancia && evento.ambulancia.placa ? evento.ambulancia.placa.upcase : nil
    nombre_empresa = evento.ambulancia && evento.ambulancia.empresa_ambulancia ? evento.ambulancia.empresa_ambulancia.nombre : nil
    nombre_escenario = evento.caso_deportivo && evento.caso_deportivo.evento_deportivo && evento.caso_deportivo.evento_deportivo.escenario ? evento.caso_deportivo.evento_deportivo.escenario.nombre : nil
    nacionalidad_value = evento.caso_deportivo ? evento.caso_deportivo.nacionalidad : nil
    diagnostico_value = evento.caso_deportivo && evento.caso_deportivo.diagnostico ? "#{evento.caso_deportivo.diagnostico.codigo} #{evento.caso_deportivo.diagnostico.nombre}" : nil
    categoria_value = evento.caso_deportivo.tipo_evento_value
    minutos_llegada = 10
    #text = "AMBULANCIA: #{nombre_empresa} #{placa}, TIEMPO APROX DE LLEGADA: #{minutos_llegada} MINUTOS, COMPLEJIDAD: #{evento.nivel_complejidad_paciente_value.upcase}"
    text = "ESCENARIO: #{nombre_escenario}, NACIONALIDAD: #{nacionalidad_value}, DIAGNOSTICO: #{diagnostico_value}, CATEGORIA: #{categoria_value}"
    text += ", PACIENTE: #{evento.paciente.nombre} #{evento.paciente.numero_documento}" if evento.paciente
    response = HTTParty.post("https://broadcaster.cm-operations.com/dashboard/broadcasterwebsms/colombia/bin/tu_empresa.php?msisdn=#{hospital_user.telefono}&message=#{text}&tag=SEMCOLOMBIA&idu=5adb64fabb241&user=VIATRANS")
  end

  def self.notificar_emails_alerta_roja(alerta, emails)
    return if emails.empty?
    RemisionMailer.new_alerta_roja(
      alerta,
      emails
    ).deliver
  end

  def self.notificar_sms_alerta_roja(alerta, telefono)
    return unless telefono.length == 10
    text = "ALERTA ROJA EN LA DIRECCION: #{alerta.direccion} OBSERVACION:#{alerta.observacion}"
    response = HTTParty.post("https://broadcaster.cm-operations.com/dashboard/broadcasterwebsms/colombia/bin/tu_empresa.php?msisdn=#{telefono}&message=#{URI::encode(text)}&tag=SEMCOLOMBIA&idu=5adb64fabb241&user=VIATRANS")
  end

end
