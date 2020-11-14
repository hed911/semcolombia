cargue_masivo = CargueMasivoPdf.last
current_usuario = Usuario.find_by_email "at_salud@barranquilla.gov.co"
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
    if filename.count < 2
      registro.enumeracion_resultado = 5
      registro.observacion_resultado = 'El nombre de archivo no es valido, no es de la forma (CC)-(11408297383)-(1)'
    end
    caso = CasoSaludPublica.find_by_tipo_documento_and_numero_documento(filename[0].upcase, filename[1])
    if caso.nil?
      registro.enumeracion_resultado = 2
      registro.observacion_resultado = 'No se encontró un paciente con los datos suministrados'
    else
      cantidad_muestras = caso.muestras.where(resultado:1, laboratorio:cargue_masivo.laboratorio).count
      if cantidad_muestras == 0
        registro.enumeracion_resultado = 3
        registro.observacion_resultado = 'No se encontró una muestra en estado pendiente para este paciente'
      elsif cantidad_muestras == 1
        muestra = caso.muestras.where(resultado:1, laboratorio:cargue_masivo.laboratorio).first
        registro.enumeracion_resultado = 1
        registro.observacion_resultado = 'Archivo subido exitosamente'
      else
        registro.enumeracion_resultado = 4
        registro.observacion_resultado = 'Se encontró mas de una muestra pendiente para este paciente'
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
      registro.archivo  = archivo_model
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
