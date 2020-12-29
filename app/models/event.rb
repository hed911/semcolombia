class Event < ActiveRecord::Base
  self.table_name = 'events'

  belongs_to :user, optional:true
  belongs_to :laboratory, optional:true
  belongs_to :institution, optional:true
  belongs_to :health_entity, optional:true
  belongs_to :insurance_carrier, optional:true
  belongs_to :country, optional:true
  belongs_to :department, optional:true
  belongs_to :city, optional:true
  belongs_to :batch, optional:true
  belongs_to :city_origin, class_name: 'City', foreign_key: 'city_origin_id', optional:true
  belongs_to :department_origin, class_name: 'Department', foreign_key: 'department_origin_id', optional:true
  belongs_to :neighborhood, optional:true
  belongs_to :diagnostico_principal, class_name: 'Diagnostic', foreign_key: 'main_diagnostic_id', optional:true
  belongs_to :city_contact_one, class_name: 'City', foreign_key: 'city_contact_one_id', optional:true
  belongs_to :department_contact_one, class_name: 'Department', foreign_key: 'department_contact_one_id', optional:true
  belongs_to :country_contact_one, class_name: 'Country', foreign_key: 'country_contact_one_id', optional:true
  belongs_to :country_one, class_name: 'Country', foreign_key: 'country_one_id', optional:true
  belongs_to :country_two, class_name: 'Country', foreign_key: 'country_two_id', optional:true
  belongs_to :user_tracking, class_name: 'User', foreign_key: 'user_tracking_id', optional:true
  belongs_to :closing_user, class_name: 'User', foreign_key: 'closing_user_id', optional:true
  belongs_to :touched_by, class_name: 'User', foreign_key: 'touched_by_id', optional:true
  belongs_to :responsible, class_name: 'User', foreign_key: 'responsible_id', optional:true
  has_many :trackings
  has_many :queries, class_name: 'Query', foreign_key: 'event_id'
  has_many :movements
  has_many :samples
  has_many :meetings

  def contacts
    Contact.where(parent:self)
  end

  def parent
    val = Contacto.where(son:self).first
    return nil if val.nil?
    return val.parent
  end

  enum state: [
    :open, 
    :closed
  ]

  def result_value
    {
      :open => 'Vigente',
      :closed  => 'Cerrado'
    }[result]
  end

  def desease_status_value
    if desease_status == 2 && is_public && !reinfection
      "Positivo"
    elsif desease_status == 3
      "Negativo"
    elsif desease_status == 4
      "Recuperado"
    elsif desease_status == 2 && is_public && reinfection
      "Reinfeccion"
    end
  end

  enum state: [
    :open, 
    :closed
  ]

  def state_value
    {
      :open => 'Vigente',
      :closed  => 'Cerrado'
    }[state]
  end

  enum tracking_status: [
    :open, 
    :requires_medicine,
    :resolved,
    :not_allowed,
    :asolated_home,
    :interned,
    :died,
    :observation,
    :finished
  ]

  def tracking_status_value
    {
      :open => 'EN SEGUIMIENTO', 
      :requires_medicine => 'REQUIERE HOSPITALIZACION', 
      :resolved => 'RESUELTO SATISFACTORIAMENTE', 
      :not_allowed => 'NO CUMPLE CON DEFINICION DE CASO', 
      :asolated_home => 'AISLAMIENTO EN CASA', 
      :interned => 'INTERNACION', 
      :died => 'FALLECIDO', 
      :observation => 'OBSERVACION', 
      :finished => 'SEGUIMIENTO FINALIZADO'
    }[tracking_status]
  end

  def state_tracking_crue_value
    if state_tracking_crue == 1
      "EN SEGUIMIENTO"
    elsif state_tracking_crue == 3
      "RESUELTO SATISFACTORIAMENTE"
    elsif state_tracking_crue == 4
      "NO CUMPLE CON DEFINICION DE CASO"
    elsif state_tracking_crue == 5
      "AISLAMIENTO EN CASA"
    end
  end

  def service_crue_value
    if service_crue == 1
      "GENERAL PEDÍATRICA"
    elsif service_crue == 2
      "GENERAR ADULTOS"
    elsif service_crue == 3
      "UCI 1/2 ADULTOS"
    elsif service_crue == 4
      "UCI 1/2 NEONATAL"
    elsif service_crue == 5
      "UCI 1/2 PEDIÁTRICO"
    elsif service_crue == 6
      "UCI ADULTOS"
    elsif service_crue == 7
      "UCI NEONATAL"
    elsif service_crue == 8
      "UCI PEDIÁTRICO"
    elsif service_crue == 9
      "EN CASA"
    elsif service_crue == 10
      "FALLECIDO"
    end
  end

  def origin_value
    return nil if user.nil?
    if user.health_entity
      user.health_entity.nombre
    elsif institution
      institution.nombre
    elsif user.institution
      user.institution.nombre
    elsif usuario.laboratory
      user.laboratory.nombre
    else
      "Sec Salud"
    end
  end

  def table_value
    return ""
    if triage == 1
      "table-success"
    elsif triage == 2
      "table-warning"
    elsif triage == 3
      "table-danger"
    end
  end

  def table_value_enfermedad
    if estado_enfermedad == 1
      ""
    elsif estado_enfermedad == 2 && publico
      "table-success"
    elsif estado_enfermedad == 2 && !publico
      ""
    elsif estado_enfermedad == 3
      "table-danger"
    elsif estado_enfermedad == 4
      "table-warning"
    end
  end

  def table_value_llamada_pendiente(usuario)
    if usuario_seguimiento == usuario
      "table-warning"
    else
      ""
    end
  end

  

  def edad_value
    return edad unless edad.nil?
    return nil if fecha_nacimiento.nil?
    age = Date.today.year - fecha_nacimiento.year
    age -= 1 if Date.today < fecha_nacimiento + age.years #for days before birthda
    age
  end

  def unidad_medida_value
    if unidad_medida == 1
      "Años"
    elsif unidad_medida == 2
      "Meses"
    elsif unidad_medida == 3
      "Dias"
    end
  end

  def regimen_value
    if regimen == 1
      "Subsidiado"
    elsif regimen == 2
      "Contributivo"
    elsif regimen == 3
      "Especial"
    elsif regimen == 4
      "P. Excepcion"
    elsif regimen == 5
      "No asegurado"
    end
  end

  def calculate_triage
    if diagnostico_principal.nil? || (diagnostico_principal && diagnostico_principal.id != 25168)
      self.triage = nil
      self.save!
      return
    end
    suma = 0
    factor_fuerte = 10 * 4
    factor_medio = 10 * 2
    factor_leve = 1
    suma += factor_medio if sintoma_covid_fiebre
    suma += factor_medio if sintoma_covid_tos
    suma += factor_medio if sintoma_covid_dificultad_respiratoria
    suma += factor_leve   if sintoma_covid_secrecion_nasal
    suma += factor_leve  if sintoma_covid_malestar_general
    suma += factor_leve  if sintoma_covid_dolor_muscular
    suma += factor_leve   if sintoma_covid_diarrea
    suma += factor_leve   if sintoma_covid_dolor_abdominal
    suma += factor_leve   if sintoma_covid_dolor_toraxico
    suma += factor_leve   if sintoma_covid_vomito
    suma += factor_fuerte if relacionamiento_con_infectados
    suma += factor_medio if ha_estado_fuera_del_pais
    if suma >= factor_fuerte
      self.triage = 3
    elsif suma >= 21
      self.triage = 2
    else
      self.triage = 1
    end
    self.save!
  end

  def service_value
    if service == 1
      "Hospitalizacion"
    elsif service == 2
      "Urgencia"
    elsif service == 3
      "UCI plena"
    elsif service == 4
      "UCI intermedia"
    elsif service == 0
      "No tiene"
    elsif service == 5
      "Ambulatorio"
    end
  end

  def infection_type_value
    if infection_type == 1
      "Importado"
    elsif infection_type == 2
      "Relacionado"
    elsif infection_type == 3
      "En estudio"
    else
      ""
    end
  end

  def generate_indexes
    index = 1
    samples.order("id ASC").each do |m|
      m.level = index
      m.save!
      index += 1
    end
  end

end
