class HistorialRecursoUrgencia < ActiveRecord::Base
  self.table_name = 'historial_recurso_urgencias'
=begin
  attr_accessible :estado_urgencia
=end
  belongs_to :institucion, optional:true
  belongs_to :usuario, optional:true

  def created_at_formatted
    created_at.strftime('%b %e, %l:%M %p')
  end

  def table_class
    case estado_urgencia
    when 1
      'success'
    when 2
      'danger'
    else
      'primary'
    end
  end

  def estado_urgencia_value
    case estado_urgencia
    when 1
      'Disponible'
    when 2
      'Colapsado'
    end
  end

end
