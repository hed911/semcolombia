class Usuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # attr_accessible :es_super_admin, :activo, :telefono, :celular, :identificacion, :cargo, :fecha_vigencia, :roles, :primer_nombre, :segundo_nombre, :primer_apellido, :segundo_apellido, :email, :password, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip
  belongs_to :municipio, optional:true
  belongs_to :departamento, optional:true
  belongs_to :municipio_alterno, :class_name => 'Municipio', :foreign_key => 'municipio_alterno_id', optional:true
  belongs_to :departamento_alterno, :class_name => 'Departamento', :foreign_key => 'departamento_alterno_id', optional:true

  belongs_to :laboratorio, optional:true
  belongs_to :institucion, optional:true
  belongs_to :entidad_prestadora, optional:true
  belongs_to :creado_por, :class_name => 'Usuario', :foreign_key => 'usuario_id', optional:true
  has_many :usuarios_creados, :class_name => 'Usuario', :foreign_key => 'usuario_id'
  has_many :reunions

  def nombre_completo
    "#{primer_nombre} #{segundo_nombre} #{primer_apellido} #{segundo_apellido}"
  end

  def roles_value
    array = ROLES if institucion.nil? && entidad_prestadora.nil?
    array = ROLES_USUARIOS_ENTIDADES_PRESTADORAS if entidad_prestadora
    array = ROLES_USUARIOS_INSTITUCIONES if institucion
    parsed_roles = []
    if roles
      roles.split(',').each do |rol|
        rol_found = array.find { |r| r[:id] == rol.to_i }
        parsed_roles << rol_found[:nombre]
      end
      parsed_roles.join(',')
    else
      ''
    end
  end

  def roles_array
    array = ROLES if institucion.nil? && entidad_prestadora.nil?
    array = ROLES_USUARIOS_ENTIDADES_PRESTADORAS if entidad_prestadora
    array = ROLES_USUARIOS_INSTITUCIONES if institucion
    parsed_roles = []
    if roles
      roles.split(',').each do |rol|
        rol_found = array.find { |r| r[:id] == rol.to_i }
        parsed_roles << rol_found
      end
    end
    parsed_roles
  end

end
