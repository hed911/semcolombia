require "resque-lock-timeout"

class StartCargueMasivoJob
  extend Resque::Plugins::LockTimeout
  @queue = :default
  @loner = true
  def self.perform(id, usuario_id)
    cargue_masivo = CargueMasivo.find_by_id id
    current_usuario = Usuario.find_by_id usuario_id
    cargue_masivo.estado = 1
    cargue_masivo.save!
    begin
      # STARTS FILE CARRIERWAVE TO NORMAL FILE
      temp_file_name = "#{Time.now.to_i}.xls"
      File.open(temp_file_name, "wb") { |f| f.write cargue_masivo.archivo.file.read }
      book = nil
      File.open(temp_file_name, "r") do |file|
        book = Spreadsheet.open file
      end
      # ENDS FILE CARRIERWAVE TO NORMAL FILE

      sheet1 = book.worksheet 0
      cargue_masivo.cantidad_registros = sheet1.count - 1
      sheet1.each do |r|
        next unless r != sheet1.first
        # TRANSFORMARMOS LOS DATOS DE LA FILA DE EXCEL A VARIABLES
        fecha_muestra = r[0]
        fecha_resultado = r[1]
        laboratorio_notifica = r[2]
        departamento = r[3]
        municipio = r[4]
        tipo_documento = r[5]
        numero_documento = r[6]
        evento = r[7]
        ips_envia = r[8]
        primer_nombre = r[9]
        segundo_nombre = r[10]
        primer_apellido = r[11]
        segundo_apellido = r[12]
        fecha_nacimiento = r[13]
        edad = r[14]
        sexo = r[15]
        condicion_final = r[16]
        eapb = r[17]
        pais_residencia = r[18]
        departamento_residencia = r[19]
        municipio_residencia = r[20]
        direccion = r[21]
        telefono = r[22]
        trabajador_salud = r[23]
        contacto_caso_confirmado = r[24]
        estado_caso = r[25]
        tipo_prueba = r[26]
        resultado = r[27]
        observaciones = r[28]

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
          caso.entidad_prestadora = current_usuario.municipio.entidad_prestadoras.where("unaccent(nombre) ILIKE '%#{eapb.downcase.strip}%'").first
          caso.institucion = current_usuario.municipio.institucions.where("unaccent(nombre) ILIKE '%#{ips_envia.downcase.strip}%'").first
          caso.country = Country.find_by_codigo("co")
          caso.departamento = current_usuario.municipio.departamento
          caso.municipio = current_usuario.municipio
          caso.departamento_origen = Departamento.where("unaccent(nombre) ILIKE '%#{departamento.downcase.strip}%'").first
          caso.municipio_origen = Municipio.where("unaccent(nombre) ILIKE '%#{municipio.downcase.strip}%'").first
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
          caso.usuario = current_usuario
          caso.save!
          caso.calculate_triage
          caso.created_at = fecha_muestra
          caso.cargue_masivo = cargue_masivo
          caso.save!
        end
        registro = Registro.create!(
          tipo_documento: tipo_documento,
          numero_documento: numero_documento.downcase.strip,
        )
        registro.cargue_masivo = cargue_masivo
        muestra = caso.muestras.where(fecha: fecha_muestra.beginning_of_day..fecha_muestra.end_of_day).first
        if resultado.downcase.strip != "en procesamiento"
          if fecha_muestra && muestra
            registro.enumeracion_resultado = 2
            registro.observacion_resultado = "Ya existe una muestra con la misma fecha"
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
            laboratorio = current_usuario.municipio.laboratorios.where("unaccent(nombre) ILIKE '%#{I18n.transliterate(laboratorio_notifica.downcase.strip)}%'").first
            if laboratorio.nil?
              laboratorio = Laboratorio.create! nombre: laboratorio_notifica.downcase.strip
              laboratorio.municipio = current_usuario.municipio
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
            muestra.cargue_masivo = cargue_masivo
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
        end
        registro.muestra = muestra
        registro.save!
      end
    rescue => error_
      cargue_masivo.errores = error_
      cargue_masivo.estado = 3
    end
    if cargue_masivo.estado == 1
      cargue_masivo.estado = 2
      cargue_masivo.fecha_finalizacion = Time.now
    end
    cargue_masivo.archivo = nil
    File.delete(temp_file_name)
    cargue_masivo.save!
  end
end
