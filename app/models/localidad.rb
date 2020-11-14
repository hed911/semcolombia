class Localidad < ActiveRecord::Base
  self.table_name = 'localidads'
  #attr_accessible :nombre,
  has_many :barrios
end
