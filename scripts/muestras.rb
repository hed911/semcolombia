
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'muestras.xls'
sheet1 = book.worksheet 0
sheet1.each do |r|
  codigo_archivo_row              = r[0]
  tipo_documento_row              = r[1]
  numero_documento_row            = r[2]
  tipo_caso_row                   = r[3] #FALTA INVOLUCRARLO
  nombre_completo_row             = r[4]
  sexo_row                        = r[5]
  edad_row                        = r[6]
  es_viajero_row                  = r[7] #FALTA INVOLUCRARLO
  departamento_row                = r[8]
  municipio_row                   = r[9]
  ips_row                         = r[10] #FALTA INVOLUCRAR
  vivo_row                        = r[11]
  resultado_row                   = r[12]
  fecha_toma_muestra_row          = r[13]
  fecha_recibo_row                = r[14]
  hora_recibo_row                 = r[15]
  fecha_procesamiento_row         = r[16]
  hora_procesamiento_row          = r[17]

  direccion_row                   = r[21]
  pais_procedencia                = r[22]

  nombres = nombre_completo_row.split(" ")
  primer_nombre = nombres[0]
  segundo_nombre = nombres[1]
  primer_apellido = nombres[2]
  segundo_apellido = nombres[3]

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
    caso.municipio                   = Municipio.find(4)
    caso.departamento                = caso.municipio.departamento
    caso.municipio_origen            = Municipio.where('lower(nombre) = ?', municipio_row.downcase).first
    caso.departamento_origen         = Departamento.where('lower(nombre) = ?', departamento_row.downcase).first
    caso.fallecido                   = vivo_row.upcase == "SI"
    caso.estado_enfermedad           = resultado_row.upcase == "P" ? 2 : 3
    caso.direccion                   = direccion_row
    caso.country                     = Country.find_by_nombre("Colombia")
    caso.nivel                       = 0
    caso.estado                      = ESTADO_SP_VIGENTE
    caso.estado_seguimiento          = 1
    caso.save!

    muestra = Muestra.create!
  end
end
