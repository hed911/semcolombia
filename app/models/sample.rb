class Sample < ActiveRecord::Base
  self.table_name = 'samples'
 
  belongs_to :laboratory, optional:true
  belongs_to :assigned_laboratory, class_name: 'Laboratory', foreign_key: 'assigned_laboratory_id', optional:true
  belongs_to :batch, optional:true
  belongs_to :institution, optional:true
  belongs_to :event, optional:true
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_user_id', optional:true
  belongs_to :finisher, class_name: 'User', foreign_key: 'finisher_id', optional:true
  belongs_to :who_receive, class_name: 'User', foreign_key: 'who_receive_id', optional:true
  belongs_to :who_dispatch, class_name: 'User', foreign_key: 'who_dispatch_id', optional:true
  has_many :attachments

  def resultado_value
    return nil if result == :negative && is_public
    {
      :positive => 'table-danger',
      :negative  => 'table-success',
      :new_sample  => 'table-warning'
    }[result]
  end

  enum type: [
    :aspirado_traqueal, 
    :lavado_broncoalveolar, 
    :hisopado_nasofaringeo,
    :aspirado_nasofaringeo
  ]

  def type_value
    {
      :aspirado_traqueal => 'Aspirado traqueal',
      :lavado_broncoalveolar  => 'Lavado broncoalveolar',
      :hisopado_nasofaringeo  => 'Hisopado nasofaringeo',
      :aspirado_nasofaringeo  => 'Aspirado nasofaringeo',
    }[type]
  end

  enum state: [
    :taken, 
    :received, 
    :assigned,
    :rejected,
    :processed
  ]

  def state_value
    {
      :taken => 'Muestra tomada',
      :received  => 'Muestra recibida por coordinador',
      :assigned  => 'Muestra asignada a laboratorio',
      :rejected  => 'Muestra rechazada',
      :processed  => 'Muestra procesada',
    }[type]
  end

  enum result: [
    :positive, 
    :negative,
    :new_sample
  ]

  def resultado_value
    return nil if result == :negative && is_public
    {
      :positive => 'Positivo',
      :negative  => 'Negativo',
      :new_sample  => 'Se solicita nueva muestra'
    }[result]
  end

  enum test: [
    :rt_pcr
  ]

  def test_value
    {
      :rt_pcr => 'RT-PCR para SARS CoV-2 (COVID-19)'
    }[test]
  end

  enum used_method: [
    :chain_reaction
  ]

  def used_method_value
    {
      :chain_reaction => 'Reacción en cadena de la polimerasa (RT-PCR) en tiempo real.'
    }[used_method]
  end

  enum test_object: [
    :diagnostic_detection
  ]

  def test_object_value
    {
      :diagnostic_detection => 'Detección diagnóstica de coronavirus Wuhan 2019 por RT-PCR - Protocolo Charité, Berlin, Alemania. 2020-01-17.'
    }[test_object]
  end

end
