Dir["archivos/*"].each do |item|
  file_name = File.basename(item, ".*")
  muestra = Muestra.find_by_codigo_archivo(file_name)
  if muestra && !muestra.archivos.any?
    archivo = File.open(item, "r")
    extension =  ".pdf"
    folder_path = "soportes/#{Time.now.year}/#{Time.now.month}"
    new_name = File.basename("#{SecureRandom.uuid}#{extension}")
    new_name = "#{folder_path}/#{new_name}"
    session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", "config_drive.json"))
    session.upload_from_file(archivo.path, new_name, convert: false)
    archivo_model = Archivo.create! full_name: new_name, real_name:"#{file_name}#{extension}"
    muestra.archivos << archivo_model
    muestra.save!
  else
    puts "NO ENCONTRADO #{file_name}"
  end
end
