class CasoSaludPublica < ActiveRecord::Base
  self.table_name = 'caso_salud_publicas'

  belongs_to :usuario, optional:true
  belongs_to :laboratorio, optional:true
  belongs_to :institucion, optional:true
  belongs_to :entidad_prestadora, optional:true
  belongs_to :aseguradora, optional:true
  belongs_to :country, optional:true
  belongs_to :departamento, optional:true
  belongs_to :municipio, optional:true
  belongs_to :cargue_masivo, optional:true
  belongs_to :municipio_origen, class_name: 'Municipio', foreign_key: 'municipio_origen_id', optional:true
  belongs_to :departamento_origen, class_name: 'Departamento', foreign_key: 'departamento_origen_id', optional:true
  belongs_to :barrio, optional:true
  belongs_to :diagnostico_principal, class_name: 'Diagnostico', foreign_key: 'diagnostico_principal_id', optional:true
  belongs_to :municipio_contacto_uno, class_name: 'Municipio', foreign_key: 'municipio_id_contacto_uno', optional:true
  belongs_to :departamento_contacto_uno, class_name: 'Departamento', foreign_key: 'departamento_id_contacto_uno', optional:true
  belongs_to :country_contacto_uno, class_name: 'Country', foreign_key: 'country_id_contacto_uno', optional:true
  belongs_to :country_uno, class_name: 'Country', foreign_key: 'country_uno_id', optional:true
  belongs_to :country_dos, class_name: 'Country', foreign_key: 'country_dos_id', optional:true
  belongs_to :usuario_seguimiento, class_name: 'Usuario', foreign_key: 'usuario_seguimiento_id', optional:true
  belongs_to :usuario_cierre, class_name: 'Usuario', foreign_key: 'usuario_cierre_id', optional:true
  belongs_to :touched_by, class_name: 'Usuario', foreign_key: 'touched_by_id', optional:true
  belongs_to :responsable_investigacion, class_name: 'Usuario', foreign_key: 'responsable_investigacion_id', optional:true
  has_many :seguimiento_casos
  has_many :consultas
  has_many :desplazamientos
  has_many :muestras
  has_many :reunions

  def contactos
    Contacto.where(parent:self)
  end

  def parent
    val = Contacto.where(son:self).first
    return nil if val.nil?
    return val.parent
  end

  def estado_value
    if estado == 1
      "Vigente"
    elsif estado == 2
      "Cerrado"
    end
  end

  def estado_enfermedad_value
    if estado_enfermedad == 1
      ""
    elsif estado_enfermedad == 2 && publico && !reinfeccion
      "Positivo"
    elsif estado_enfermedad == 2 && !publico
      ""
    elsif estado_enfermedad == 3
      "Negativo"
    elsif estado_enfermedad == 4
      "Recuperado"
    elsif estado_enfermedad == 2 && publico && reinfeccion
      "Reinfeccion"
    end
  end

  def estado_seguimiento_value
    if estado_seguimiento == 1
      "EN SEGUIMIENTO"
    elsif estado_seguimiento == 2
      "REQUIERE HOSPITALIZACION"
    elsif estado_seguimiento == 3
      "RESUELTO SATISFACTORIAMENTE"
    elsif estado_seguimiento == 4
      "NO CUMPLE CON DEFINICION DE CASO"
    elsif estado_seguimiento == 5
      "AISLAMIENTO EN CASA"
    elsif estado_seguimiento == 6
      "INTERNACION"
    elsif estado_seguimiento == 7
      "FALLECIDO"
    elsif estado_seguimiento == 8
      "OBSERVACION"
    elsif estado_seguimiento == 9
      "SEGUIMIENTO FINALIZADO"
    end
  end

  def estado_seguimiento_crue_value
    if estado_seguimiento_crue == 1
      "EN SEGUIMIENTO"
    elsif estado_seguimiento_crue == 3
      "RESUELTO SATISFACTORIAMENTE"
    elsif estado_seguimiento_crue == 4
      "NO CUMPLE CON DEFINICION DE CASO"
    elsif estado_seguimiento_crue == 5
      "AISLAMIENTO EN CASA"
    end
  end

  def servicio_crue_value
    if servicio_crue == 1
      "GENERAL PEDÍATRICA"
    elsif servicio_crue == 2
      "GENERAR ADULTOS"
    elsif servicio_crue == 3
      "UCI 1/2 ADULTOS"
    elsif servicio_crue == 4
      "UCI 1/2 NEONATAL"
    elsif servicio_crue == 5
      "UCI 1/2 PEDIÁTRICO"
    elsif servicio_crue == 6
      "UCI ADULTOS"
    elsif servicio_crue == 7
      "UCI NEONATAL"
    elsif servicio_crue == 8
      "UCI PEDIÁTRICO"
    elsif servicio_crue == 9
      "EN CASA"
    elsif servicio_crue == 10
      "FALLECIDO"
    end
  end

  def sexo_value
    if sexo == 1
      "M"
    elsif sexo == 2
      "F"
    end
  end

  def origen_value
    return nil if usuario.nil?
    if usuario.entidad_prestadora
      usuario.entidad_prestadora.nombre
    elsif institucion
      institucion.nombre
    elsif usuario.institucion
      usuario.institucion.nombre
    elsif usuario.laboratorio
      usuario.laboratorio.nombre
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

  def nombre_completo
    "#{primer_nombre} #{segundo_nombre} #{primer_apellido} #{segundo_apellido}"
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

  def servicio_value
    if servicio == 1
      "Hospitalizacion"
    elsif servicio == 2
      "Urgencia"
    elsif servicio == 3
      "UCI plena"
    elsif servicio == 4
      "UCI intermedia"
    elsif servicio == 0
      "No tiene"
    elsif servicio == 5
      "Ambulatorio"
    end
  end

  def tipo_contagio_value
    if tipo_contagio == 1
      "Importado"
    elsif tipo_contagio == 2
      "Relacionado"
    elsif tipo_contagio == 3
      "En estudio"
    else
      ""
    end
  end

  def generate_indexes
    index = 1
    muestras.order("id ASC").each do |m|
      m.nivel = index
      m.save!
      index += 1
    end
  end

end
