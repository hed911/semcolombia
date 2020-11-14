class CustomTable < ActiveRecord::Base
  self.table_name = 'custom_tables'
=begin
  attr_accessible :observacion,
                  :estado,
                  :notificacion_de_apoyo,
                  :causa,
                  :fecha_apoyo,
                  :fecha_cierre
=end

  belongs_to :primer_respondiente, optional:true
  belongs_to :evento_primer_respondiente, optional:true
  has_one :imagen

  def estado_value
    if estado == 1
      "PENDIENTE"
    elsif estado == 2
      "APOYO NOTIFICADO"
    elsif estado == 3
      "CERRADO"
    elsif estado == 4
      "RECHAZADO"
    end
  end

end
