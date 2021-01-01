class AttachmentsController < ApplicationController
  require "net/http"
  
  before_action :authenticate_user!, except: [:show, :generate_and_download]
  protect_from_forgery :except => []

  def show
    attachment = Attachment.find_by_uuid params[:id]
    config_str = "config_drive.json"
    session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", config_str))
    file = session.file_by_title(attachment.full_name)
    send_data file.download_to_string,
              filename: archivo.real_name,
              type: file.mime_type
  end

  def generate_and_download
    sample = Sample.find_by_id params[:id]
    event = sample.event
    data = {
      name: event.full_name.upcase,
      document_number: "#{event.document_type} #{event.document_number}",
      department: event.city && event.city.department ? event.city.department.name.upcase : "",
      regime: event.regime_value,
      health_entity: sample.sismuestra_eapb ? sample.sismuestra_eapb.upcase : "",
      laboratory: sample.laboratorio ? sample.laboratorio.nombre.upcase : nil,
      result: sample.resultado_value.upcase,
      type: sample.sismuestra_tipoprueba,
      date: sample.date ? sample.date.strftime("%Y/%m/%d") : "",
      processing_date: sample.sismuestra_result_date ? sample.sismuestra_result_date.strftime("%Y/%m/%d") : "",
      creation_date: sample.created_at.strftime("%Y/%m/%d %I:%M:%S%p"),
      download_date: "Generado a través de SemCovid: #{Time.now.strftime("%Y/%m/%d %I:%M:%S%p")}",
      observations: sample.observations
    }

    #pdftk = PdfForms.new("/usr/local/bin/pdftk") #LOCALHOST
    pdftk = PdfForms.new("#{Rails.root}/vendor/pdftk/bin/pdftk") #HEROKU
    new_file_path = "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf"

    model_path = nil
    if !params[:municipio_id].nil?
      model_path = "scripts/model_#{params[:municipio_id]}.pdf"
    elsif event.municipio
      model_path = "scripts/model_#{event.municipio.id}.pdf"
    else
      model_path = "scripts/model_default.pdf"
    end
    if model_path.nil? || File.exist?(model_path)
      model_path = "scripts/model_default.pdf"
    end
    pdftk.fill_form model_path, new_file_path, data, flatten: true
    send_file new_file_path
  end
   
end
