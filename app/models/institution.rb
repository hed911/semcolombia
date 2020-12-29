class Institution < ActiveRecord::Base
  include Common

  self.table_name = 'institutions'

  has_many :users
  belongs_to :city, optional:true
  belongs_to :alternate_city, class_name: 'City', foreign_key: 'alternate_city_id', optional:true
  belongs_to :health_entity, optional:true
  belongs_to :parent, class_name: 'Institution', foreign_key: 'parent_id', optional:true
  has_many :sedes, class_name: 'Institution', foreign_key: 'parent_id'

  geocoded_by :full_street_address
  after_validation :geocode

  enum level: [
    :no_established, 
    :low, 
    :medium,
    :high
  ]

  def level_value
    {
      :in_progress => 'No tiene',
      :low  => 'Baja',
      :medium  => 'Media',
      :high  => 'Alta'
    }[level]
  end

  enum complexity_level: [
    :one, 
    :two, 
    :three,
    :four
  ]

  def complexity_level_value
    {
      :one => 'I',
      :two  => 'II',
      :three => 'III',
      :four  => 'IV'
    }[complexity_level]
  end

  enum emergency_state: [
    :available, 
    :collapsed
  ]

  def emergency_state_value
    {
      :available => 'Disponible',
      :collapsed  => 'Colapsado'
    }[level]
  end

  def full_street_address
    ''
  end

  def roles_value
    parsed_roles = []
    if roles
      roles.split(',').each do |rol|
        rol_found = ROLES_INSTITUTIONS.find { |r| r[:id] == rol.to_i }
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
        rol_found = ROLES_INSTITUTIONS.find { |r| r[:id] == rol.to_i }
        parsed_roles << rol_found
      end
    end
    parsed_roles
  end

  def level_value
    {
      :available => 'Disponible',
      :collapsed  => 'Colapsado'
    }[emergency_state]
  end

  def table_class
    {
      :available => 'success',
      :collapsed  => 'danger'
    }[emergency_state]
  end

end
