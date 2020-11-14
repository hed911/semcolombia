class HistorialUrgencia < ActiveRecord::Base
  self.table_name = 'historial_urgencias'
=begin
  attr_accessible :heridos_arma_fuego,
                  :heridos_arma_blanca,
                  :heridos_arma_contundente,
                  :heridos_accidente_transito,
                  :urgencias_totales_atendidas,
                  :pacientes_observacion,
                  :cirugias_urgencias
=end
  belongs_to :institucion, optional:true
  belongs_to :usuario, optional:true
  belongs_to :hospital_user, optional:true

  def created_at_formatted
    created_at.strftime('%b %e, %l:%M %p')
  end

  def table_class
    if TimeDifference.between(created_at, Time.now).in_hours.to_i >= 12
      'danger'
    else
      'success'
    end
  end
end
