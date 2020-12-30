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

  enum state_tracking_crue: [
    :in_tracking, 
    :resolved,
    :not_well_defined,
    :isolated_home,
  ]

  def state_tracking_crue_value
    {
      :in_tracking => 'EN SEGUIMIENTO', 
      :resolved => 'RESUELTO SATISFACTORIAMENTE', 
      :not_well_defined => 'NO CUMPLE CON DEFINICION DE CASO', 
      :isolated_home => 'AISLAMIENTO EN CASA'
    }[state_tracking_crue]
  end

  enum service_crue: [
    :type_one, 
    :type_two,
    :type_three,
    :type_four,
    :type_five, 
    :type_six,
    :type_seven,
    :type_eight,
    :type_nine,
    :type_ten,
  ]

  def service_crue_value
    {
      :type_one => 'GENERAL PEDÍATRICA', 
      :type_two  => 'GENERAR ADULTOS', 
      :type_three  => 'UCI 1/2 ADULTOS', 
      :type_four  => 'UCI 1/2 NEONATAL', 
      :type_five  => 'UCI 1/2 PEDIÁTRICO', 
      :type_six  => 'UCI ADULTOS', 
      :type_seven  => 'UCI NEONATAL', 
      :type_eight  => 'UCI PEDIÁTRICO', 
      :type_nine  => 'EN CASA', 
      :type_ten  => 'FALLECIDO'
    }[service_crue]
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
    {
      :1 => 'table-success', 
      :2 => 'table-warning', 
      :3 => 'table-danger', 
    }[triage]
  end

  def table_value_enfermedad
    if estado_enfermedad == 2 && publico
      "table-success"
    elsif estado_enfermedad == 3
      "table-danger"
    elsif estado_enfermedad == 4
      "table-warning"
    end
  end

  def table_value_llamada_pendiente(usuario)
    usuario_seguimiento == usuario ? "table-warning" : ""
  end  

  def edad_value
    return edad unless edad.nil?
    return nil if fecha_nacimiento.nil?
    age = Date.today.year - fecha_nacimiento.year
    age -= 1 if Date.today < fecha_nacimiento + age.years #for days before birthda
    age
  end

  enum measure_units: [
    :years, 
    :months,
    :days
  ]

  def measure_units_value
    {
      :years => 'Años', 
      :months  => 'Meses', 
      :days  => 'Dias'
    }[measure_units]
  end

  enum regime: [
    :type_one, 
    :type_two,
    :type_three,
    :type_four, 
    :type_five
  ]

  def regime_value
    {
      :type_one => 'Subsidiado', 
      :type_two  => 'Contributivo', 
      :type_three  => 'Especial',
      :type_four => 'P. Excepcion', 
      :type_five  => 'No asegurado'
    }[regime]
  end

  def calculate_triage
    if diagnostico_principal.nil? || (diagnostico_principal && diagnostico_principal.id != 25168)
      self.triage = nil
      self.save!
      return
    end
    hash = {
      :sintoma_covid_fiebre => MEDIUM_FACTOR,
      :sintoma_covid_tos => MEDIUM_FACTOR,
      :sintoma_covid_dificultad_respiratoria => MEDIUM_FACTOR,
      :sintoma_covid_secrecion_nasal => LOW_FACTOR,
      :sintoma_covid_malestar_general => LOW_FACTOR,
      :sintoma_covid_dolor_muscular => LOW_FACTOR,
      :sintoma_covid_diarrea => LOW_FACTOR,
      :sintoma_covid_dolor_abdominal => LOW_FACTOR,
      :sintoma_covid_dolor_toraxico => LOW_FACTOR,
      :sintoma_covid_vomito => LOW_FACTOR,
      :relacionamiento_con_infectados => HIGH_FACTOR,
      :ha_estado_fuera_del_pais => MEDIUM_FACTOR
    }
    sum = hash.keys.select{ |e| self[e] == true }.inject(0){ |a, e| a + hash[e] }
    if suma >= HIGH_FACTOR
      self.triage = HIGH_LEVEL
    elsif suma >= 21
      self.triage = MID_LEVEL
    else
      self.triage = LOW_LEVEL
    end
    self.save!
  end

  enum service: [
    :type_one, 
    :type_two,
    :type_three,
    :type_four, 
    :type_five,
    :type_six
  ]

  def service_value
    {
      :type_one => 'Hospitalizacion', 
      :type_two  => 'Urgencia', 
      :type_three  => 'UCI plena',
      :type_four => 'UCI intermedia', 
      :type_five  => 'No tiene', 
      :type_six  => 'Ambulatorio'
    }[service_value]
  end

  enum infection_type: [
    :imported, 
    :related,
    :in_study
  ]

  def infection_type_value
    {
      :imported => 'Importado', 
      :related  => 'Relacionado', 
      :in_study  => 'En estudio'
    }[infection_type]
  end

  def generate_indexes
    samples.order('id ASC').each_with_index{ |m, i| m.update_attribute(:level, i + 1) }
  end

end
