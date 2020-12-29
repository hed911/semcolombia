class City < ActiveRecord::Base
  self.table_name = 'cities'

  belongs_to :department, optional:true
  has_many :neighborhoods
  has_many :users
  has_many :institutions
  has_many :zones
  has_many :laboratories, foreign_key: "city_id", class_name: "City"
  has_and_belongs_to_many :health_entities, class_name:"HealthEntity", join_table: "cities_health_entities"
end
