
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'campana.xls'
sheet1 = book.worksheet 0
is_first = true
sheet1.each do |r|
  if is_first
    is_first = false
    next
  end
  nombre_completo_row             = r[1]
  edad_row                        = r[2]
  fecha_nacimiento_row            = r[3]
  tipo_documento_row              = 'CC'
  numero_documento_row            = r[4]
  embarazo_row                    = r[7]
  control_prenatal_row            = r[8]
  tiempo_embarazo_row             = r[9]
  telefono_row                    = r[10].to_i
  email_row                       = r[11]
  antecedentes_row                = r[12]

  nombres                         = nombre_completo_row.split(" ")
  primer_nombre_row               = nombres[0]
  segundo_nombre_row              = nombres[1]
  primer_apellido_row             = nombres[2]
  segundo_apellido_row            = nombres[3]

  numero_documento_row            = numero_documento_row.to_s.gsub(".0", "")


  puts "primer_nombre:#{primer_nombre_row}"
  puts "segundo_nombre:#{segundo_nombre_row}"
  puts "primer_apellido:#{primer_apellido_row}"
  puts "segundo_apellido:#{segundo_apellido_row}"
  puts "edad:#{edad_row}"
  puts "fecha_nacimiento:#{fecha_nacimiento_row}"
  puts "tipo_documento:#{tipo_documento_row}"
  puts "numero_documento:#{numero_documento_row}"
  puts "embarazo:#{embarazo_row}"
  puts "control_prenatal:#{control_prenatal_row}"
  puts "tiempo_embarazo:#{tiempo_embarazo_row}"
  puts "telefono:#{telefono_row}"
  puts "email:#{email_row}"
  puts "antecedentes:#{antecedentes_row}"
  puts "EMBARAZADA:#{embarazo_row}\nCONTROL PRENATAL:#{control_prenatal_row}\nTIEMPO EMBARAZO:#{tiempo_embarazo_row.to_i}\nANTECEDENTES:#{antecedentes_row}"
  puts ""
  puts ""

  caso = CasoSaludPublica.find_by_tipo_documento_and_numero_documento(tipo_documento_row, numero_documento_row)
  if caso.nil?
    caso = CasoSaludPublica.create!
    caso.tipo_documento              = tipo_documento_row.upcase
    caso.numero_documento            = numero_documento_row
    caso.primer_nombre               = primer_nombre_row
    caso.segundo_nombre              = segundo_nombre_row
    caso.primer_apellido             = primer_apellido_row
    caso.segundo_apellido            = segundo_apellido_row
    caso.telefono                    = telefono_row
    caso.email                       = email_row
    caso.sexo                        = 2
    caso.edad                        = edad_row
    caso.fecha_nacimiento            = fecha_nacimiento_row
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
    caso.observacion                 = "EMBARAZADA:#{embarazo_row}\nCONTROL PRENATAL:#{control_prenatal_row}\nTIEMPO EMBARAZO:#{tiempo_embarazo_row.to_i}\nANTECEDENTES:#{antecedentes_row}"
    caso.save!
  end
end
