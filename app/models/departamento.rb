class Departamento < ActiveRecord::Base
  self.table_name = 'departamentos'
  #attr_accessible :codigo_dane, :nombre
  has_many :municipios
  has_many :usuarios

  def table_class
    if municipios.none? && usuarios.none?
      'danger'
    else
      'success'
    end
  end
end
