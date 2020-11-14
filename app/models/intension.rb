class Intension < ActiveRecord::Base
  self.table_name = 'intensions'
  #attr_accessible :nombre
  belongs_to :municipio, optional:true
  has_many :llamadas
end
