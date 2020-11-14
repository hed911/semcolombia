class Laboratorio < ActiveRecord::Base
  self.table_name = 'laboratorios'
  #attr_accessible :nombre, :direccion, :telefono, :nit, :coordinacion
  belongs_to :municipio, optional:true
  has_many :usuarios
end


