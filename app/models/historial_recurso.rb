class HistorialRecurso < ActiveRecord::Base
=begin
  attr_accessible :pacientes_uci_glasgow,
                  :sueros_antiofilicos,
                  :sangres_ab_positivo,
                  :sangres_ab_negativo,
                  :sangres_b_positivo,
                  :sangres_b_negativo,
                  :sangres_o_positivo,
                  :sangres_o_negativo,
                  :sangres_a_positivo,
                  :sangres_a_negativo,
                  :cantidad_uci_quemados,
                  :cantidad_uci_medio_adulto,
                  :cantidad_uci_adulto,
                  :cantidad_uci_medio_pediatrico,
                  :cantidad_uci_pediatrico,
                  :cantidad_uci_medio_neonato,
                  :cantidad_uci_neonato,
                  :cantidad_piso
=end
  belongs_to :institucion, optional: true
  belongs_to :usuario, optional: true
  belongs_to :hospital_user, optional: true

  def total_sangres
    total = 0
    total += sangres_ab_positivo if sangres_ab_positivo
    total += sangres_ab_negativo if sangres_ab_negativo
    total += sangres_b_positivo if sangres_b_positivo
    total += sangres_b_negativo if sangres_b_negativo
    total += sangres_o_positivo if sangres_o_positivo
    total += sangres_o_negativo if sangres_o_negativo
    total += sangres_a_positivo if sangres_a_positivo
    total += sangres_a_negativo if sangres_a_negativo
    total
  end

  def total_camas
    total = 0
    total += adultos if adultos
    total += cuidado_agudo_mental if cuidado_agudo_mental
    total += cuidado_basico_neonatal if cuidado_basico_neonatal
    total += cuidado_intensivo_adulto if cuidado_intensivo_adulto
    total += cuidado_intensivo_neonatal if cuidado_intensivo_neonatal
    total += cuidado_intensivo_pediatrico if cuidado_intensivo_pediatrico
    total += cuidado_intermedio_adulto if cuidado_intermedio_adulto
    total += cuidado_intermedio_mental if cuidado_intermedio_mental
    total += cuidado_intermedio_neonatal if cuidado_intermedio_neonatal
    total += cuidado_intermedio_pediatrico if cuidado_intermedio_pediatrico
    total += farmacodependencia if farmacodependencia
    total += institucion_paciente_cronico if institucion_paciente_cronico
    total += obstetricia if obstetricia
    total += pediatrica if pediatrica
    total += psiquiatrica if psiquiatrica
    total += salud_mental if salud_mental
    total += transplante_de_progenitores_hematopoyeticos if transplante_de_progenitores_hematopoyeticos
    total
  end

  def created_at_formatted
    created_at.strftime("%b %e, %l:%M %p")
  end

  def table_class
    if Time.now.beginning_of_day <= created_at && created_at <= Time.now.end_of_day
      "table-success"
    else
      "table-danger"
    end
  end
end
