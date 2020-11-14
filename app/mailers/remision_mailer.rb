require 'digest/sha2'
class RemisionMailer < ActionMailer::Base
  default :from => 'sandbox4910b51e313042908486a3f34376c5da.mailgun.org', 'Message-ID' => "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@sem.com"
  def nueva_remision_eps(super_remision, entidad_prestadora) # TO EAPB
    @super_remision = super_remision
    entidad_prestadora.hospital_users.each do |hospital_user|
      mail(to: [hospital_user.email], subject: "Nueva remision de #{super_remision.institucion_emisor ? super_remision.institucion_emisor.nombre : ''}")
    end
  end

  def remision_prevalidada(super_remision) # TO EMISOR
    @super_remision = super_remision
    super_remision.institucion_emisor.hospital_users.each do |hospital_user|
      mail(to: [hospital_user.email], subject: "Remision ##{super_remision.id} prevalidada por #{super_remision.ingreso && super_remision.ingreso.entidad_prestadora ? super_remision.ingreso.entidad_prestadora.nombre : ''}")
    end
  end

  def remision_lista_para_aceptar_por_ips(super_remision) # TO RECEPTORES
    @super_remision = super_remision
    super_remision.remisions.each do |remision|
      remision.institucion_receptor.hospital_users.each do |hospital_user|
        mail(to: [hospital_user.email], subject: 'Solicitud de remision requiere aprobacion')
      end
    end
  end

  def remision_aceptada_por_ips(super_remision) # TO EMISOR
    @super_remision = super_remision
    super_remision.remisions.each do |remision|
      remision.institucion_emisor.hospital_users.each do |hospital_user|
        mail(to: [hospital_user.email], subject: "Remision ##{super_remision.id} asignada a #{super_remision.institucion_receptor.nombre if super_remision.institucion_receptor}")
      end
    end
  end

  def remision_prevalidada_por_crue(super_remision) # TO EAPB
    @super_remision = super_remision
    super_remision.ingreso.entidad_prestadora.usuarios.each do |hospital_user|
      mail(to: [hospital_user.email], subject: 'Sec de salud ha auditado una remision vencida')
    end
  end

  def remision_cerrada(super_remision) # TO EAPB
    @super_remision = super_remision
    super_remision.institucion_emisor.hospital_users.each do |hospital_user|
      mail(to: [hospital_user.email], subject: "Remision ##{super_remision.id} ha sido cerrada por #{super_remision.institucion_receptor.nombre if super_remision.institucion_receptor}")
    end
  end

  def create_user_instructions(nombre, email, password, roles)
    @nombre = nombre
    @email = email
    @password = password
    @roles = roles
    mail(to: [email], subject: "#{nombre} bienvenido a la plataforma SEM")
  end

  def new_evento_ambulatorio(evento, emails)
    @evento = evento
    mail(to: emails, subject: "Nuevo servicio de ambulancia SEM")
  end

  def new_alerta_roja(alerta, emails)
    @alerta = alerta
    mail(to: emails, subject: "Alerta Roja")
  end

  def new_caso(muestra, emails)
    @muestra = muestra
    @caso = muestra.caso_salud_publica
    mail(to: emails, subject: "COVID-19 resultado POSITIVO")
  end

end
