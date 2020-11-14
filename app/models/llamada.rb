class Llamada < ActiveRecord::Base
  self.table_name = 'llamadas'
  #attr_accessible :descripcion, intension
  belongs_to :caso_salud_publica, optional:true
  belongs_to :usuario, optional:true
  belongs_to :intension, optional:true
  belongs_to :departamento, optional:true
  belongs_to :municipio, optional:true

  def nombre_completo
    "#{primer_nombre} #{segundo_nombre} #{primer_apellido} #{segundo_apellido}"
  end

  def table_value
    if caso_salud_publica
      "table-warning"
    else
      ""
    end
  end

end
