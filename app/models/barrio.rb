class Barrio < ActiveRecord::Base
  self.table_name = "barrios"
  #attr_accessible :nombre,
  belongs_to :localidad, optional: true
  belongs_to :municipio, optional: true
end
