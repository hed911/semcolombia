class Municipio < ActiveRecord::Base
  self.table_name = 'municipios'
  #attr_accessible :nombre, :default_latitude, :default_longitude, :habilitado_remisiones, :habilitado_autorizaciones
  belongs_to :departamento, optional:true
  has_many :barrios
  has_many :usuarios
  has_many :institucions
  has_many :zonas
  has_many :empresa_ambulancias
  has_many :ambulancias
  has_many :laboratorios
  has_and_belongs_to_many :entidad_prestadoras

  def sql_postgis
    result = ''
    zonas.each do |zona|
      inner_string = ''
      zona.puntos.each do |punto|
        inner_string += "#{punto.longitude} #{punto.latitude},"
      end
      inner_string = inner_string[0..-2] if inner_string != ''
      result = "((#{inner_string})),"
    end
    result = result[0..-2] if result != ''
    "MULTIPOLYGON(#{result})"
  end
end
