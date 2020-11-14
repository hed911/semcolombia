class Muestra < ActiveRecord::Base
  self.table_name = 'muestras'
  #attr_accessible :fecha, :tipo, :resultado, :otro_tipo, :temperatura, :observaciones, :codigo_analista, :codigo_responsable_tecnico
  belongs_to :laboratorio, optional:true #Laboratorio encargado de recibir y hacer despacho
  belongs_to :laboratorio_asignado, class_name: 'Laboratorio', foreign_key: 'laboratorio_asignado_id', optional:true
  #Laboratorio encargado de recibir y hacer despacho
  belongs_to :cargue_masivo, optional:true
  belongs_to :institucion, optional:true
  belongs_to :caso_salud_publica, optional:true
  belongs_to :emisor, class_name: 'Usuario', foreign_key: 'usuario_emisor_id', optional:true
  belongs_to :finalizador, class_name: 'Usuario', foreign_key: 'usuario_finalizador_id', optional:true
  belongs_to :quien_recibe, class_name: 'Usuario', foreign_key: 'quien_recibe_id', optional:true
  belongs_to :quien_despacha, class_name: 'Usuario', foreign_key: 'quien_despacha_id', optional:true
  has_many :archivos

  def table_value
    if resultado == 1
      ""
    elsif resultado == 2 && publico
      "table-danger"
    elsif resultado == 2 && !publico
      ""
    elsif resultado == 3
      "table-success"
    elsif resultado == 4
      "table-warning"
    end
  end

  def tipo_value
    if tipo == 1
      "Aspirado traqueal"
    elsif tipo == 2
      "Lavado broncoalveolar"
    elsif tipo == 3
      "Hisopado nasofaringeo"
    elsif tipo == 4
      "Aspirado nasofaringeo"
    elsif tipo == 5
      otro_tipo
    end
  end

  def estado_value
    if estado == 1
      "Muestra tomada"
    elsif estado == 2
      "Muestra recibida por coordinador"
    elsif estado == 3
      "Muestra asignada a laboratorio"
    elsif estado == 4
      "Muestra rechazada"
    elsif estado == 5
      "Muestra procesada"
    end
  end

  def resultado_value
    if resultado == 1
      "Por definir"
    elsif resultado == 2 && publico
      "Positivo"
    elsif resultado == 2 && !publico
      ""
    elsif resultado == 3
      "Negativo"
    elsif resultado == 4
      "Se solicita nueva muestra"
    end
  end

  def prueba_value
    if prueba == 1
      "RT-PCR para SARS CoV-2 (COVID-19)"
    end
  end

  def metodo_utilizado_value
    if metodo_utilizado == 1
      "Reacción en cadena de la polimerasa (RT-PCR) en tiempo real."
    end
  end

  def objeto_prueba_value
    if objeto_prueba == 1
      "Detección diagnóstica de coronavirus Wuhan 2019 por RT-PCR - Protocolo Charité, Berlin, Alemania. 2020-01-17."
    end
  end
end
