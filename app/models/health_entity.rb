class HealtEntity < ActiveRecord::Base
  self.table_name = 'health_entities'

  has_many :users
  has_many :institutions
  has_and_belongs_to_many :cities, class_name:"City", join_table: "cities"

  validates :name, presence: true

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
