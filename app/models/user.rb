class User < ActiveRecord::Base
  include Common
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :city, optional:true
  belongs_to :department, optional:true
  belongs_to :alternative_city, :class_name => 'City', :foreign_key => 'alternative_city_id', optional:true
  belongs_to :alternative_department, :class_name => 'Department', :foreign_key => 'alternative_department_id', optional:true
  belongs_to :laboratory, optional:true
  belongs_to :institution, optional:true
  belongs_to :health_entity, optional:true
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'user_id', optional:true
  has_many :crated_users, :class_name => 'User', :foreign_key => 'user_id'
  has_many :meetings

  validates :name, :email, presence: true
  validates :email, confirmation: { case_sensitive: false }
  validates :email, uniqueness: true

  def roles_value
    array = ROLES if institution.nil? && health_entity.nil?
    array = ROLES_HEALTH_ENTITY_USERS if health_entity
    array = ROLES_INSTITUTION_USERS if institution
    parsed_roles = []
    if roles
      roles.split(',').each do |rol|
        rol_found = array.find { |r| r[:id] == rol.to_i }
        parsed_roles << rol_found[:name]
      end
      parsed_roles.join(',')
    else
      ''
    end
  end

  def roles_array
    array = ROLES if institution.nil? && health_entity.nil?
    array = ROLES_HEALTH_ENTITY_USERS if health_entity
    array = ROLES_INSTITUTION_USERS if institution
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
