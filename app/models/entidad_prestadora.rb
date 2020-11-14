class EntidadPrestadora < ActiveRecord::Base
  self.table_name = 'entidad_prestadoras'
  #attr_accessible :codigo, :nombre, :especial
  has_many :usuarios
  has_many :institucions
  has_and_belongs_to_many :municipios

  def roles_value
    parsed_roles = []
    if roles
      roles.split(',').each do |rol|
        rol_found = ROLES_ENTIDADES_PRESTADORAS.find { |r| r[:id] == rol.to_i }
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
        rol_found = ROLES_ENTIDADES_PRESTADORAS.find { |r| r[:id] == rol.to_i }
        parsed_roles << rol_found
      end
    end
    parsed_roles
  end

end
