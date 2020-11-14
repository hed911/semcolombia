class AdjuntosController < ApplicationController
  require "net/http"
  before_action :authenticate_usuario!
  protect_from_forgery :except => []

  def upload
    archivo = params[:archivo]
    extension = File.extname(archivo.original_filename)
    folder_path = "soportes/#{Time.now.year}/#{Time.now.month}"
    new_name = File.basename("#{SecureRandom.uuid}#{extension}")
    new_name = "#{folder_path}/#{new_name}"
    session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", "config_drive.json"))
    session.upload_from_file(archivo.path, new_name, convert: false)
    archivo_model = Archivo.create! full_name: new_name, real_name: archivo.original_filename
    return render json: { id: archivo_model.id }.to_json
  end

  def download
    archivo = Archivo.find_by_id params[:id]
    config_str = "config_drive.json"
    session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", config_str))
    file = session.file_by_title(archivo.full_name)
    send_data file.download_to_string,
              filename: "#{archivo.real_name}",
              type: file.mime_type
  end
end
