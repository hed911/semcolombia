
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'muestras.xls'
sheet1 = book.worksheet 0
barranquilla = Municipio.find(4)
first = true
sheet1.each do |r|
  if first
    first = false
    next
  end
  numero_muestra_row              = r[0]
  id_row                          = r[1]
  tipo_row                        = r[2]
  estado_row                      = r[3]
  nombre_completo_row             = r[4]
  tipo_documento_row              = r[5]
  numero_documento_row            = r[6].to_s.gsub('.0', '')
  eapb_row                        = r[7]
  ips_row                         = r[8]
  servicio_row                    = r[9]
  laboratorio_row                 = r[10]
  fecha_procesamiento             = r[11]
  fecha_toma_muestra              = r[12]
  fecha_recibido                  = r[13]

  nombres = nombre_completo_row.split(" ")
  primer_nombre = nombres[0]
  segundo_nombre = nombres[1]
  primer_apellido = nombres[2]
  segundo_apellido = nombres[3]

=begin
  puts "numero_muestra_row: #{numero_muestra_row}"
  puts "id_row: #{id_row}"
  puts "tipo_row: #{tipo_row}"
  puts "estado_row: #{estado_row}"
  puts "tipo_documento_row: #{tipo_documento_row}"
  puts "numero_documento_row: #{numero_documento_row}"
  puts "eapb_row: #{eapb_row}"
  puts "ips_row: #{ips_row}"
  puts "servicio_row: #{servicio_row}"
  puts "laboratorio_row: #{numero_muestra_row}"
  puts "fecha_procesamiento: #{fecha_procesamiento}"
  puts "fecha_toma_muestra: #{fecha_toma_muestra}"
  puts "fecha_recibido: #{fecha_recibido}"

  puts "numero_muestra_row: #{laboratorio_row}"
  puts "primer_nombre: #{primer_nombre}"
  puts "segundo_nombre: #{segundo_nombre}"
  puts "primer_apellido: #{primer_apellido}"
  puts "segundo_apellido: #{segundo_apellido}"
  puts "\n"
  puts "\n"
  puts "\n"
=end

  #entidad_prestadora = EntidadPrestadora.where(municipio:barranquilla, nombre:eapb_row.downcase) if eapb_row

  caso = CasoSaludPublica.find_by_tipo_documento_and_numero_documento(tipo_documento_row, numero_documento_row)
  if caso.nil?
    caso = CasoSaludPublica.create!
    caso.tipo_documento              = tipo_documento_row.upcase
    caso.numero_documento            = numero_documento_row
    caso.primer_nombre               = primer_nombre
    caso.segundo_nombre              = segundo_nombre
    caso.primer_apellido             = primer_apellido
    caso.segundo_apellido            = segundo_apellido
    caso.municipio                   = barranquilla
    caso.departamento                = caso.municipio.departamento
    caso.municipio_origen            = barranquilla
    caso.departamento_origen         = caso.municipio_origen.departamento

    caso.estado_enfermedad           = 3
    #caso.direccion                   = direccion_row
    caso.country                     = Country.find_by_nombre("Colombia")
    caso.nivel                       = 0
    caso.estado                      = ESTADO_SP_VIGENTE
    caso.estado_seguimiento          = 1
    caso.especial                    = true
    caso.created_at                  = fecha_toma_muestra if !fecha_toma_muestra.nil? && !fecha_toma_muestra == ""
    caso.save!
  end

  muestra = Muestra.create!
  muestra.codigo_archivo = numero_muestra_row
  muestra.caso_salud_publica = caso
  muestra.fecha = fecha_toma_muestra
  muestra.fecha_recepcion_interna = fecha_recibido
  muestra.fecha_despacho_interna = fecha_recibido
  muestra.fecha_realizacion = fecha_procesamiento
  muestra.resultado = 3
  muestra.estado = 5
  muestra.publico = false
  muestra.especial = true
  muestra.created_at = fecha_toma_muestra if !fecha_toma_muestra.nil? && !fecha_toma_muestra == ""
  muestra.save!

  caso.generate_indexes

end
