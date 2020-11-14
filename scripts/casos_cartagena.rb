
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'casos_cartagena.xls'
sheet1 = book.worksheet 0
is_first = true
sheet1.each do |r|
  if is_first
    is_first = false
    next
  end
  email                           = r[0]
  nombre_completo_row             = r[1]
  sexo_row                        = r[2]
  edad_row                        = r[3]
  tipo_documento_row              = r[5]
  numero_documento_row            = r[6]
  telefono_row                    = r[7]
  observacion_row                 = r[8]

  nombres = nombre_completo_row.split(" ")
  primer_nombre = nombres[0]
  segundo_nombre = nombres[1]
  primer_apellido = nombres[2]
  segundo_apellido = nombres[3]

  numero_documento_row            = numero_documento_row.to_s.gsub(".0", "")

  caso = CasoSaludPublica.find_by_tipo_documento_and_numero_documento(tipo_documento_row, numero_documento_row)
  if caso.nil?
    caso = CasoSaludPublica.create!
    caso.tipo_documento              = tipo_documento_row.upcase
    caso.numero_documento            = numero_documento_row
    caso.primer_nombre               = primer_nombre
    caso.segundo_nombre              = segundo_nombre
    caso.primer_apellido             = primer_apellido
    caso.segundo_apellido            = segundo_apellido
    caso.sexo                        = sexo_row.upcase == "M" ? 1 : 2
    caso.edad                        = edad_row
    caso.municipio                   = Municipio.find(27)
    caso.departamento                = caso.municipio.departamento
    caso.municipio_origen            = Municipio.find(27)
    caso.departamento_origen         = caso.municipio_origen.departamento
    caso.estado_enfermedad           = 1
    caso.country                     = Country.find_by_nombre("Colombia")
    caso.nivel                       = 0
    caso.estado                      = ESTADO_SP_VIGENTE
    caso.estado_seguimiento          = 1
    caso.especial                    = true
    caso.institucion                 = Institucion.find(6346)
    caso.observacion                 = observacion_row
    caso.save!
  end
end
