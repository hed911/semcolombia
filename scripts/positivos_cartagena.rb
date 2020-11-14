
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'positivos_cartagena.xls'
sheet1 = book.worksheet 0
sheet1.each do |r|
  codigo_row                      = r[0]
  primer_nombre                   = r[2]
  segundo_nombre                  = r[3]
  primer_apellido                 = r[4]
  segundo_apellido                = r[5]
  tipo_documento_row              = r[6]
  numero_documento_row            = r[7]
  codigo_eps_row                  = r[8]
  nombre_eps_row                  = r[9]
  fecha_nacimiento_row            = r[10]
  edad_row                        = r[11]
  sexo_row                        = r[12]
  barrio_row                      = r[13]
  direccion_row                   = r[14]
  estado_row                      = r[15]
  tipo_row                        = r[16]

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
    caso.fecha_nacimiento            = fecha_nacimiento_row
    caso.direccion                   = direccion_row
    caso.municipio                   = Municipio.find(27)
    caso.departamento                = caso.municipio.departamento
    caso.municipio_origen            = Municipio.find(27)
    caso.departamento_origen         = caso.municipio_origen.departamento
    if tipo_row.nil?
      caso.estado_enfermedad           = 1
    else
      if tipo_row.upcase == 'POSITIVO'
        caso.estado_enfermedad         = 2
        caso.publico                   = true
      elsif tipo_row == 'NEGATIVO'
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
    #caso.fallecido                   = !estado_row.nil? && estado_row.upcase.include?("FALLECIDO")
    caso.observacion                 = "#{codigo_row},#{nombre_eps_row}"
    caso.save!

    if tipo_row && tipo_row.upcase == 'POSITIVO' || tipo_row.upcase == 'NEGATIVO'
      muestra = Muestra.create!
      muestra.caso_salud_publica = caso
      muestra.fecha = Time.now
      muestra.fecha_recepcion_interna = Time.now
      muestra.fecha_despacho_interna = Time.now
      muestra.fecha_realizacion = Time.now
      if tipo_row.upcase == 'POSITIVO'
        muestra.resultado = 2
        muestra.publico = true
      elsif tipo_row == 'NEGATIVO'
        muestra.resultado = 3
      end
      muestra.estado = 5
      muestra.especial = true
      muestra.created_at = Time.now
      muestra.save!
    end

    caso.generate_indexes
  end
end
