class Diagnostico < ActiveRecord::Base
  self.table_name = 'diagnosticos'
  #attr_accessible :nombre, :cantidad_horas_limite, :codigo
  belongs_to :super_remision, optional:true
  has_many :caso_deportivos
end
