class NotificacionEmergente < ActiveRecord::Base
  self.table_name = 'notificacion_emergentes'
  #attr_accessible :estado, :nombre
  belongs_to :municipio, optional:true
  belongs_to :entidad_prestadora, optional:true
  belongs_to :institucion, optional:true
  belongs_to :usuario, optional:true

  def estado_value
    if estado == 1
      'No leido'
    elsif estado == 2
      'Leido'
    end
  end

  def created_at_formatted
    created_at.strftime('%m/%e/%Y %l:%M %p')
  end
end
