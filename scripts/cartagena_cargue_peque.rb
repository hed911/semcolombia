
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'cargue_peque.xls'
sheet1 = book.worksheet 0
sheet1.each do |r|
  tipo_documento_row              = r[0]
  numero_documento_row            = r[1]
  primer_nombre                   = r[2]
  primer_apellido                 = r[3]
  segundo_apellido                = r[4]
  segundo_nombre                  = ''
  telefono_row                    = r[5]
  direccion_row                   = r[6]

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
    caso.telefono                    = telefono_row
    caso.direccion                   = direccion_row
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
    caso.save!

    muestra = Muestra.create!
    muestra.caso_salud_publica = caso
    muestra.fecha = Time.now
    muestra.fecha_recepcion_interna = Time.now
    muestra.fecha_despacho_interna = Time.now
    muestra.fecha_realizacion = Time.now
    muestra.estado = 1
    muestra.especial = true
    muestra.created_at = Time.now
    muestra.save!

    caso.generate_indexes
  end
end
