require 'resque-lock-timeout'
class StartCargueMasivoPdfJob
  extend Resque::Plugins::LockTimeout
  @queue = :default
  @loner = true
  def self.perform(id, usuario_id)
    cargue_masivo = CargueMasivoPdf.find_by_id id
    current_usuario = Usuario.find_by_id usuario_id
    cargue_masivo.estado = 1
    cargue_masivo.save!
    begin
      temp_file_name = "#{Time.now.to_i}.zip"
      File.open(temp_file_name, 'wb') { |f| f.write cargue_masivo.archivo.file.read }
      FileUtils.rm_rf(Dir['temp_zip/*'])
      Zip::ZipFile.open(temp_file_name) { |zip_file|
        zip_file.each { |f|
          f_path=File.join("temp_zip", f.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(f, f_path) unless File.exist?(f_path)
        }
      }
      Dir.glob('temp_zip/**/*').select{ |e| File.file? e }.each do |path|
        archivo = File.open(path)
        filename =  File.basename(path, ".*")
        filename = filename.strip.split("-") # TI-11408298393-1
        registro = RegistroPdf.create!
        muestra = nil
        muestras = []
        if filename.count != 1
          registro.enumeracion_resultado = 5
          registro.observacion_resultado = 'El nombre de archivo no es valido'
        else
          caso = CasoSaludPublica.find_by_numero_documento(filename[0])
          #registro.tipo_documento = filename[0].upcase
          registro.numero_documento = filename[0]
          if caso.nil?
            registro.enumeracion_resultado = 2
            registro.observacion_resultado = 'No se encontró un paciente con los datos suministrados'
          else
            muestras = caso.muestras.where(resultado:[1, 2, 3], laboratorio:cargue_masivo.laboratorio).to_a
            muestras.each do |muestra|
              muestras.delete(muestra) if muestra.archivos.any?
            end
            cantidad_muestras = muestras.count
            if cantidad_muestras == 0
              registro.enumeracion_resultado = 3
              registro.observacion_resultado = 'No se encontró una posible muestra para adjuntarle el archivo con las condiciones dadas'
            elsif cantidad_muestras == 1
              muestra = muestras.first
              if muestra.resultado != 1
                begin
                  resultado = PdfValidationHelper.es_positivo?(archivo) ? 2 : 3
                  if muestra.resultado != resultado
                    registro.enumeracion_resultado = 7
                    registro.observacion_resultado = 'El resultado del PDF no coincide con el resultado de la muestra'
                  end
                rescue
                  registro.enumeracion_resultado = 6
                  registro.observacion_resultado = 'Ocurrió un problema al extraer el texto interno del archivo PDF'
                end
              else
                registro.enumeracion_resultado = 1
                registro.observacion_resultado = 'Archivo subido exitosamente'
              end
            else
              registro.enumeracion_resultado = 4
              registro.observacion_resultado = 'Se encontró mas de una muestra posible para este PDF'
            end
          end
        end
        registro.cargue_masivo_pdf = cargue_masivo
        if registro.enumeracion_resultado == 1
          folder_path = "soportes/#{Time.now.year}/#{Time.now.month}"
          new_name = File.basename("#{SecureRandom.uuid}.pdf")
          new_name = "#{folder_path}/#{new_name}"
          session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", "config_drive.json"))
          session.upload_from_file(archivo.path, new_name, convert: false)
          archivo_model = Archivo.create! full_name: new_name, real_name:new_name
          archivo_model.cargue_masivo_pdf = cargue_masivo
          archivo_model.save!
          muestra.archivos = [archivo_model]
          begin
            muestra.resultado = PdfValidationHelper.es_positivo?(archivo) ? 2 : 3
            muestra.estado = 5
            muestra.fecha_procesado_interna = Time.now
          rescue
            puts "FALLÓ LA EXTRACCION DEL CONTENIDO DEL PDF"
          end
          muestra.save!
        elsif registro.enumeracion_resultado == 2
          caso = CasoSaludPublica.create! numero_documento:registro.numero_documento, especial:true, sin_datos:true
          caso.municipio = current_usuario.municipio
          caso.save!
          muestra = Muestra.create! estado:1, resultado:1, especial:true
          muestra.caso_salud_publica = caso
          muestra.save!
          folder_path = "soportes/#{Time.now.year}/#{Time.now.month}"
          new_name = File.basename("#{SecureRandom.uuid}.pdf")
          new_name = "#{folder_path}/#{new_name}"
          session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", "config_drive.json"))
          session.upload_from_file(archivo.path, new_name, convert: false)
          archivo_model = Archivo.create! full_name: new_name, real_name:new_name
          archivo_model.cargue_masivo_pdf = cargue_masivo
          archivo_model.save!
          registro.estado_alterno = 1
          registro.tipo = 2 #PARA DIFERENCIAR QUE ESTE ES UN CASO CREADO DE 0
          muestra.archivos = [archivo_model]
          begin
            muestra.resultado = PdfValidationHelper.es_positivo?(archivo) ? 2 : 3
            muestra.estado = 5
            muestra.fecha_procesado_interna = Time.now
          rescue
            puts "FALLÓ LA EXTRACCION DEL CONTENIDO DEL PDF"
          end
          muestra.save!
        elsif registro.enumeracion_resultado == 4
          folder_path = "soportes/#{Time.now.year}/#{Time.now.month}"
          new_name = File.basename("#{SecureRandom.uuid}.pdf")
          new_name = "#{folder_path}/#{new_name}"
          session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", "config_drive.json"))
          session.upload_from_file(archivo.path, new_name, convert: false)
          archivo_model = Archivo.create! full_name: new_name, real_name:new_name
          archivo_model.cargue_masivo_pdf = cargue_masivo
          archivo_model.save!
          registro.estado_alterno = 1
          registro.tipo = 1 #PARA DIFERENCIAR QUE ESTE ES UN CONFLICTO DE MUESTRAS
          registro.archivo  = archivo_model
          begin
            registro.resultado = PdfValidationHelper.es_positivo?(archivo) ? 2 : 3
          rescue
            puts "FALLÓ LA EXTRACCION DEL CONTENIDO DEL PDF"
          end
        end
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
    FileUtils.rm_rf(Dir['temp_zip/*'])
    cargue_masivo.save!
  end
end
