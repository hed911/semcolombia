# STARTS FILE CARRIERWAVE TO NORMAL FILE
temp_file_name = "manual.xlsx"
book = nil
creek = Creek::Book.new temp_file_name
# ENDS FILE CARRIERWAVE TO NORMAL FILE
sheet1 = creek.sheets[0]
r_zero = sheet1.rows.first
first = true

sheet1.rows.each_slice(1000) do |group|
  registros = []
  group.each do |r|
    if first
      first = false
      next
    end
    keys = r.keys

    fecha_muestra = r[keys[0]]
    fecha_resultado = r[keys[1]]
    laboratorio_notifica = r[keys[2]]
    departamento = r[keys[3]]
    municipio = r[keys[4]]
    tipo_documento = r[keys[5]]
    numero_documento = r[keys[6]].to_s.gsub(".0", "")
    evento = r[keys[7]]
    ips_envia = r[keys[8]]
    primer_nombre = r[keys[9]]
    segundo_nombre = r[keys[10]]
    primer_apellido = r[keys[11]]
    segundo_apellido = r[keys[12]]
    fecha_nacimiento = r[keys[13]]
    edad = r[keys[14]]
    sexo = r[keys[15]]
    condicion_final = r[keys[16]]
    eapb = r[keys[17]]
    pais_residencia = r[keys[18]]
    departamento_residencia = r[keys[19]]
    municipio_residencia = r[keys[20]]
    direccion = r[keys[21]]
    telefono = r[keys[22]]
    trabajador_salud = r[keys[23]]
    contacto_caso_confirmado = r[keys[24]]
    estado_caso = r[keys[25]]
    tipo_prueba = r[keys[26]]
    resultado = r[keys[27]]
    observaciones = r[keys[28]]

    tipo_documento = I18n.transliterate(tipo_documento.downcase.strip)
    if tipo_documento == "adulto sin identificar"
      tipo_documento = "AS"
    elsif tipo_documento == "cedula de ciudadania"
      tipo_documento = "CC"
    elsif tipo_documento == "cedula de extranjeria"
      tipo_documento = "CE"
    elsif tipo_documento == "certificado de nacido vivo"
      tipo_documento = "NV"
    elsif tipo_documento == "menor sin identificar"
      tipo_documento = "MS"
    elsif tipo_documento == "otro"
      tipo_documento = "OTRO"
    elsif tipo_documento == "pasaporte"
      tipo_documento = "PA"
    elsif tipo_documento == "permiso especial de permanencia"
      tipo_documento = "PE"
    elsif tipo_documento == "registro civil"
      tipo_documento = "RC"
    elsif tipo_documento == "sin dato"
      tipo_documento = "OTRO"
    elsif tipo_documento == "tarjeta de identidad"
      tipo_documento = "TI"
    else
      tipo_documento = "OTRO"
    end

    if !sexo.nil?
      sexo = I18n.transliterate(sexo.downcase.strip)
      if sexo == "femenino"
        sexo = 2
      elsif sexo == "masculino"
        sexo = 1
      end
    end

    caso = CasoSaludPublica.find_by_tipo_documento_and_numero_documento(tipo_documento, numero_documento.strip)
    if caso.nil?
      caso = CasoSaludPublica.create!
      caso.primer_nombre = primer_nombre
      caso.primer_apellido = primer_apellido
      caso.segundo_nombre = segundo_nombre
      caso.segundo_apellido = segundo_apellido
      caso.fecha_nacimiento = fecha_nacimiento
      caso.edad = edad
      caso.unidad_medida = 1
      caso.tipo_documento = tipo_documento
      caso.numero_documento = numero_documento.strip
      caso.sexo = sexo
      if eapb
        caso.entidad_prestadora = Municipio.find(4).entidad_prestadoras.where("unaccent(nombre) ILIKE '%#{eapb.downcase.strip}%'").first
      end
      if ips_envia
        caso.institucion = Municipio.find(4).institucions.where("unaccent(nombre) ILIKE '%#{ips_envia.downcase.strip}%'").first
      end
      caso.country = Country.find_by_codigo("co")
      caso.departamento = Municipio.find(4).departamento
      caso.municipio = Municipio.find(4)
      if departamento
        caso.departamento_origen = Departamento.where("unaccent(nombre) ILIKE '%#{departamento.downcase.strip}%'").first
      end
      if municipio
        caso.municipio_origen = Municipio.where("unaccent(nombre) ILIKE '%#{municipio.downcase.strip}%'").first
      end
      caso.direccion = direccion
      caso.telefono = telefono
      caso.observacion = evento.tr("\n", "").tr("\r", "").tr(";", ",") if evento
      caso.diagnostico_principal = Diagnostico.find_by_id("25168")
      if trabajador_salud
        caso.es_trabajador_de_salud = trabajador_salud.downcase.strip == "si"
      end
      if condicion_final
        caso.fallecido = condicion_final.downcase.strip == "muerto"
      end

      caso.nivel = 0
      caso.estado = ESTADO_SP_VIGENTE
      caso.estado_seguimiento = 1
      caso.estado_enfermedad = 1
      caso.fecha_actualizacion_estado_enfermedad = Time.now
      caso.save!
      caso.calculate_triage
      caso.created_at = fecha_muestra
      caso.save!
    end
    registro = Registro.create!(
      tipo_documento: tipo_documento,
      numero_documento: numero_documento.downcase.strip,
    )
    muestra = caso.muestras.where(fecha: fecha_muestra.beginning_of_day..fecha_muestra.end_of_day).first
    if fecha_muestra && muestra
      registro.enumeracion_resultado = 2
      registro.observacion_resultado = "Ya existe una muestra con la misma fecha"
      if resultado.downcase.strip == "positivo"
        muestra.resultado = 2
      elsif resultado.downcase.strip == "negativo"
        muestra.resultado = 3
      else
        muestra.resultado = 4
      end
      muestra.save!
      if muestra.resultado != 4
        if caso.estado_enfermedad == 2 && resultado == 3
          caso.estado_enfermedad = 4
        else
          caso.estado_enfermedad = resultado
        end
        caso.fecha_actualizacion_estado_enfermedad = Time.now
        if caso.ha_estado_infectado && (caso.estado_enfermedad == 3 || caso.estado_enfermedad == 4) && resultado == 2
          caso.reinfeccion = true
        end
      end
      if caso.estado_enfermedad == 2
        caso.ha_estado_infectado = true
      end
      muestra.estado = 5
      muestra.save!
    else
      laboratorio = Municipio.find(4).laboratorios.where("unaccent(nombre) ILIKE '%#{I18n.transliterate(laboratorio_notifica.downcase.strip)}%'").first
      if laboratorio.nil?
        laboratorio = Laboratorio.create! nombre: laboratorio_notifica.downcase.strip
        laboratorio.municipio = Municipio.find(4)
        laboratorio.save!
      end
      muestra = Muestra.create! estado: 5
      if resultado.downcase.strip == "positivo"
        muestra.resultado = 2
      elsif resultado.downcase.strip == "negativo"
        muestra.resultado = 3
      else
        muestra.resultado = 4
      end
      muestra.fecha = fecha_muestra
      muestra.fecha_realizacion = fecha_resultado
      muestra.otro_tipo = tipo_prueba
      muestra.caso_salud_publica = caso
      muestra.institucion = caso.institucion
      muestra.laboratorio = laboratorio
      muestra.observaciones = observaciones.tr("\n", "").tr("\r", "").tr(";", ",") if observaciones
      muestra.save!
      caso.generate_indexes
      registro.enumeracion_resultado = 1
      registro.observacion_resultado = "OK"

      if muestra.resultado != 4
        if caso.estado_enfermedad == 2 && resultado == 3
          caso.estado_enfermedad = 4
        else
          caso.estado_enfermedad = resultado
        end
        caso.fecha_actualizacion_estado_enfermedad = Time.now
        if caso.ha_estado_infectado && (caso.estado_enfermedad == 3 || caso.estado_enfermedad == 4) && resultado == 2
          caso.reinfeccion = true
        end
      end
      if caso.estado_enfermedad == 2
        caso.ha_estado_infectado = true
      end
      muestra.save!
      caso.save!
    end
    registro.muestra = muestra
    registro.save!
  end
end
