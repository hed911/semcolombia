class RegistroPdf < ActiveRecord::Base
  #   attr_accessible
  #   :tipo_documento,
  #   :numero_documento,
  #   :enumeracion_resultado,
  #   :observacion_resultado

  belongs_to :archivo, optional: true
  belongs_to :muestra, optional: true
  belongs_to :cargue_masivo_pdf, optional: true

  def enumeracion_resultado_value
    if enumeracion_resultado == 1
      "PDF SUBIDO EXITOSAMENTE"
    elsif enumeracion_resultado == 2
      "NUMERO IDENTIFICACION/TIPO NO ENCONTRADO"
    elsif enumeracion_resultado == 3
      "MUESTRA PENDIENTE NO ENCONTRADA PARA EL LAB ESPECIFICADO"
    elsif enumeracion_resultado == 4
      "MAS DE UNA MUESTRA PENDIENTE"
    elsif enumeracion_resultado == 5
      "NOMBRE DE ARCHIVO INVALIDO"
    elsif enumeracion_resultado == 6
      "EXTRACCION DE TEXTO FALLIDA"
    end
  end

  def class_value
    if enumeracion_resultado == 1
      "table-success"
    else
      "table-danger"
    end
  end

end
