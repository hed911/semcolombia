class Institucion < ActiveRecord::Base
  self.table_name = 'institucions'
=begin
# attr_accessible :telefono_contacto_uno, :telefono_contacto_dos, :telefono_contacto_tres, :telefono_contacto_cuatro, :telefono_contacto_cinco,
 :email_contacto_uno, :email_contacto_dos, :email_contacto_tres, :email_contacto_cuatro, :email_contacto_cinco,
                  :roles,
                  :codigo,
                  :numero_sede,
                  :nombre,
                  :direccion,
                  :telefono,
                  :email,
                  :nit,
                  :dv,
                  :clase_persona,
                  :naju_nombre,
                  :ese,
                  :caracter,
                  :grse_nombre,
                  :serv_nombre,

                  :ambulatorio,
                  :hospitalario,
                  :unidad_movil,
                  :domiciliario,
                  :otras_extramural,
                  :centro_referencia,
                  :institucion_remisora,
                  :fecha_apertura,
                  :fecha_cierre,
                  :numero_distintivo,
                  :numero_sede_principal,

                  :activo,
                  :latitude,
                  :longitude,
                  :nivel,
                  :nivel_complejidad,
                  :distancia,
                  :estado_urgencia
=end
  has_many :ingresos
  has_many :usuarios
  has_many :historial_recursos
  has_many :historial_recurso_urgencias
  has_and_belongs_to_many :categoria_referencias

  geocoded_by :full_street_address
  after_validation :geocode
  belongs_to :municipio, optional:true
  belongs_to :municipio_alterno, class_name: 'Municipio', foreign_key: 'municipio_alterno_id', optional:true

  has_many :camas
  belongs_to :entidad_prestadora, optional:true

  belongs_to :parent, class_name: 'Institucion', foreign_key: 'parent_id', optional:true
  has_many :sedes, class_name: 'Institucion', foreign_key: 'parent_id'

  def cantidad_camas_disponibles_by_tipo(tipo_cama)
    camas.where(tipo_cama: tipo_cama, estado: 1).count
  end

  def cantidad_camas_ocupadas_by_tipo(tipo_cama)
    camas.where(tipo_cama: tipo_cama, estado: 2).count
  end

  def nivel_value #nivel
    case nivel
    when 0
      'No Tiene'
    when 1
      'Baja'
    when 2
      'Media'
    when 3
      'Alta'
    end
  end

  def nivel_complejidad_value #nivel_complejidad
    case nivel_complejidad
    when 1
      'I'
    when 2
      'II'
    when 3
      'III'
    when 4
      'IV'
    end
  end

  def estado_urgencia_value
    case estado_urgencia
    when 1
      'Disponible'
    when 2
      'Colapsado'
    end
  end

  def full_street_address
    ''
  end

  def created_at_formatted
    created_at.strftime('%e %b %Y %I:%m:%S%p')
  end

  def roles_value
    parsed_roles = []
    if roles
      roles.split(',').each do |rol|
        rol_found = ROLES_INSTITUCIONES.find { |r| r[:id] == rol.to_i }
        parsed_roles << rol_found[:nombre]
      end
      parsed_roles.join(',')
    else
      ''
    end
  end

  def roles_array
    parsed_roles = []
    if roles
      roles.split(',').each do |rol|
        rol_found = ROLES_INSTITUCIONES.find { |r| r[:id] == rol.to_i }
        parsed_roles << rol_found
      end
    end
    parsed_roles
  end

  def cantidad_camas_disponibles
    camas.where(estado: 1).count
  end

  def last_recurso
    historial_recursos.last
  end

  def virtual_users
    result = []
    result << HospitalUser.new(
      email: email_contacto_uno,
      password:"12345678",
      password_confirmation:"12345678",
      telefono: telefono_contacto_uno
    )
    result << HospitalUser.new(
      email: email_contacto_dos,
      password:"12345678",
      password_confirmation:"12345678",
      telefono: telefono_contacto_dos
    )
    result << HospitalUser.new(
      email: email_contacto_tres,
      password:"12345678",
      password_confirmation:"12345678",
      telefono: telefono_contacto_tres
    )
    result << HospitalUser.new(
      email: email_contacto_cuatro,
      password:"12345678",
      password_confirmation:"12345678",
      telefono: telefono_contacto_cuatro
    )
    result << HospitalUser.new(
      email: email_contacto_cinco,
      password:"12345678",
      password_confirmation:"12345678",
      telefono: telefono_contacto_cinco
    )
    result << HospitalUser.new(
      email: email_contacto_seis,
      password:"12345678",
      password_confirmation:"12345678",
      telefono: telefono_contacto_seis
    )
    result
  end

  def table_class
    case estado_urgencia
    when 1
      'success'
    when 2
      'danger'
    else
      'primary'
    end
  end

end
