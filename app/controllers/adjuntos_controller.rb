class AdjuntosController < ApplicationController
  require "net/http"
  before_action :authenticate_usuario!
  protect_from_forgery :except => []

  def upload
    attachment = params[:attachment]
    extension = File.extname(attachment.original_filename)
    folder_path = "soportes/#{Time.now.year}/#{Time.now.month}"
    new_name = File.basename("#{SecureRandom.uuid}#{extension}")
    new_name = "#{folder_path}/#{new_name}"
    session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", "config_drive.json"))
    session.upload_from_file(attachment.path, new_name, convert: false)
    attachment_model = Attachment.create! full_name: new_name, real_name: attachment.original_filename
    return render json: { id: attachment_model.id }.to_json
  end

  def download
    attachment = Attachment.find_by_id params[:id]
    config_str = "config_drive.json"
    session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", config_str))
    file = session.file_by_title(attachment.full_name)
    send_data file.download_to_string,
              filename: "#{attachment.real_name}",
              type: file.mime_type
  end
end
