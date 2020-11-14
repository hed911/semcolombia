def parse_item(item, municipio)
  puts item["ID"]
  fecha_muestra = DateTime.strptime(item["FechaMuestra"], "%Y-%m-%dT%H:%M:%S")
  fecha_resultado = DateTime.strptime(item["FechaResultado"], "%Y-%m-%dT%H:%M:%S")
  laboratorio_notifica = item["LaboratorioNotifica"]
  departamento = item["Departamento"]
  municipio_ = item["Municipio"]
  tipo_documento = item["TipoDocumento"]
  numero_documento = item["Documento"]
  evento = item["Evento"]
  ips_envia = item["IPS_Envia"]
  primer_nombre = item["PrimerNombre"]
  segundo_nombre = item["SegundoNombre"]
  primer_apellido = item["PrimerApellido"]
  segundo_apellido = item["SegundoApellido"]
  fecha_nacimiento = item["FechaNacimiento"] ? DateTime.strptime(item["FechaNacimiento"], "%Y-%m-%dT%H:%M:%S") : nil
  edad = item["Edad"]
  sexo = item["Sexo"]
  condicion_final = item["CondicionFinal"]
  eapb = item["EAPB"]
  pais_residencia = item["PaisResidencia"]
  departamento_residencia = item["DepartamentoResidencia"]
  municipio_residencia = item["MunicipioResidencia"]
  direccion = item["Direccion"]
  telefono = item["Telefono"]
  trabajador_salud = item["TrabajadorSalud"]
  contacto_caso_confirmado = item["ContactoCasoConfirmado"]
  tipo_prueba = item["TipoPrueba"]
  resultado = item["Resultado"]
  observaciones = item["Observaciones"]

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

  sexo = I18n.transliterate(sexo.downcase.strip)
  if sexo == "femenino"
    sexo = 2
  elsif sexo == "masculino"
    sexo = 1
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
    caso.entidad_prestadora = municipio.entidad_prestadoras.where("unaccent(nombre) ILIKE '%#{eapb.downcase.strip}%'").first
    caso.institucion = municipio.institucions.where("unaccent(nombre) ILIKE '%#{ips_envia.downcase.strip}%'").first
    caso.country = Country.find_by_codigo("co")
    caso.departamento = municipio.departamento
    caso.municipio = municipio
    caso.departamento_origen = Departamento.where("unaccent(nombre) ILIKE '%#{departamento.downcase.strip}%'").first
    caso.municipio_origen = Municipio.where("unaccent(nombre) ILIKE '%#{municipio_.downcase.strip}%'").first
    caso.direccion = direccion
    caso.telefono = telefono
    caso.observacion = evento.tr("\n", "").tr("\r", "").tr(";", ",") if evento
    caso.diagnostico_principal = Diagnostico.find_by_id("25168")

    caso.es_trabajador_de_salud = trabajador_salud.downcase.strip == "si"
    caso.fallecido = condicion_final.downcase.strip == "muerto"

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
  muestra = caso.muestras.where(fecha: fecha_muestra.beginning_of_day..fecha_muestra.end_of_day).first
  if resultado.downcase.strip != "en procesamiento"
    if fecha_muestra && muestra
      if resultado.downcase.strip == "positivo"
        muestra.resultado = 2
      elsif resultado.downcase.strip == "negativo"
        muestra.resultado = 3
      elsif resultado.downcase.strip == "sin procesar"
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
      laboratorio = municipio.laboratorios.where("unaccent(nombre) ILIKE '%#{I18n.transliterate(laboratorio_notifica.downcase.strip)}%'").first
      if laboratorio.nil?
        laboratorio = Laboratorio.create! nombre: laboratorio_notifica.downcase.strip
        laboratorio.municipio = municipio
        laboratorio.save!
      end
      muestra = Muestra.create! estado: 5
      if resultado.downcase.strip == "positivo"
        muestra.resultado = 2
      elsif resultado.downcase.strip == "negativo"
        muestra.resultado = 3
      elsif resultado.downcase.strip == "sin procesar"
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
  end
end

url = "https://apps.ins.gov.co/SisMuestrasApi/api/resultados"
USUARIOS_WS_SISMUESTRA.each do |usuario_ws|
  municipio = Municipio.find(usuario_ws[:municipio_id])
  token = Base64.encode64("#{usuario_ws[:username]}:#{usuario_ws[:password]}")
  page = 1
  total_pages = nil
  loop do
    response = HTTParty.get("#{url}?pagina=#{page}",
                            {
      body: {},
      headers: {
        'Content-Type': "application/json",
        'Authorization': "Basic #{token}",
      },
    })
    response = response.parsed_response
    next if response["estado"] != "exitoso"
    total_pages = response["totalPaginas"] if total_pages.nil?
    response["datos"].each do |item|
      parse_item(item, municipio)
    end
    page += 1
    break unless page <= total_pages
  end
end
