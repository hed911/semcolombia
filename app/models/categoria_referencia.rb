class CategoriaReferencia < ActiveRecord::Base
  self.table_name = 'categoria_referencias'
  #attr_accessible :nombre
  has_and_belongs_to_many :institucions
  belongs_to :municipio, optional:true
end
