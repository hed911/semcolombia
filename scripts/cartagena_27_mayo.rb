
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'cartagena.xls'
sheet1 = book.worksheet 0
sheet1.each do |r|
  codigo_evento                   = r[0]
  fecha_notificacion              = r[1]
  primer_nombre                   = r[2]
  segundo_nombre                  = r[3]
  primer_apellido                 = r[4]
  segundo_apellido                = r[5]
  tipo_documento                  = r[6]
  numero_documento                = r[7]
  edad                            = r[8]
  sexo                            = r[9]
  barrio                          = r[10]
  direccion                       = r[11]
  codigo_eps                      = r[12]
  resultado                       = r[14]
  telefono                        = r[15]
  fecha_nacimiento                = r[16]
  numero_documento                = numero_documento.to_s.gsub(".0", "")

  caso = CasoSaludPublica.find_by_tipo_documento_and_numero_documento(tipo_documento, numero_documento)
  if caso.nil?
    caso = CasoSaludPublica.create!
    caso.tipo_documento              = tipo_documento.upcase
    caso.numero_documento            = numero_documento
    caso.primer_nombre               = primer_nombre
    caso.segundo_nombre              = segundo_nombre
    caso.primer_apellido             = primer_apellido
    caso.segundo_apellido            = segundo_apellido
    caso.sexo                        = sexo.upcase == "M" ? 1 : 2
    caso.edad                        = edad
    caso.fecha_nacimiento            = fecha_nacimiento
    caso.direccion                   = direccion
    caso.municipio                   = Municipio.find(27)
    caso.departamento                = caso.municipio.departamento
    caso.municipio_origen            = Municipio.find(27)
    caso.departamento_origen         = caso.municipio_origen.departamento
    caso.entidad_prestadora          = EntidadPrestadora.where("unaccent(codigo) ILIKE '%#{codigo_eps.downcase.strip}%'").first
    if resultado.nil? || resultado == 'PROBABLE'
      caso.estado_enfermedad           = 1
    else
      if resultado.upcase == 'POSITIVO'
        caso.estado_enfermedad         = 2
        caso.publico                   = true
      elsif resultado == 'NEGATIVO'
        caso.estado_enfermedad         = 3
      else
        caso.estado_enfermedad         = 1
      end
    end
    caso.country                     = Country.find_by_nombre("Colombia")
    caso.nivel                       = 0
    caso.estado                      = ESTADO_SP_VIGENTE
    caso.estado_seguimiento          = 1
    caso.especial                    = true
    caso.save!
  end
  if !caso.muestras.any?
    muestra = Muestra.create!
    muestra.caso_salud_publica = caso
    muestra.fecha = Time.now
    muestra.fecha_recepcion_interna = Time.now
    muestra.fecha_despacho_interna = Time.now
    muestra.fecha_realizacion = Time.now
    if resultado.upcase == 'POSITIVO'
      muestra.estado = 5
      muestra.resultado = 2
      muestra.publico = true
    elsif resultado == 'NEGATIVO'
      muestra.estado = 5
      muestra.resultado = 3
    elsif resultado == 'PROBABLE'
      muestra.estado = 3
      muestra.resultado = 1
    end
    muestra.especial = true
    muestra.created_at = Time.now
    muestra.save!
  end
  caso.generate_indexes
end
