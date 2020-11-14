class Registro < ActiveRecord::Base
  #   attr_accessible
  #   :tipo_documento,
  #   :numero_documento,
  #   :enumeracion_resultado,
  #   :observacion_resultado

  belongs_to :muestra, optional: true
  belongs_to :cargue_masivo, optional: true

  def enumeracion_resultado_value
    if enumeracion_resultado == 1
      "REGISTRO CREADO EXITOSAMENTE"
    elsif enumeracion_resultado == 2
      "REGISTRO REPETIDO"
    elsif enumeracion_resultado == 3
      "OTRO ERROR"
    end
  end

  def class_value
    if enumeracion_resultado == 1
      "success"
    elsif enumeracion_resultado == 2
      "danger"
    end
  end

end
