class FilesController < ApplicationController
  require "net/http"
  before_action :authenticate_usuario!, except: [:show, :generate_and_download]
  protect_from_forgery except: [:create]

  def show
    archivo = Attachment.find_by_uuid params[:id]
    config_str = "config_drive.json"
    session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", config_str))
    file = session.file_by_title(archivo.full_name)
    send_data file.download_to_string,
              filename: archivo.real_name,
              type: file.mime_type
  end

  def generate_and_download
    muestra = Muestra.find_by_id params[:id]
    caso = muestra.caso_salud_publica
    data = {
      nombre: caso.nombre_completo.upcase,
      numero_documento: "#{caso.tipo_documento} #{caso.numero_documento}",
      departamento: caso.municipio && caso.municipio.departamento ? caso.municipio.departamento.nombre.upcase : "",
      regimen: caso.regimen_value,
      entidad_prestadora: muestra.sismuestra_eapb ? muestra.sismuestra_eapb.upcase : "",
      laboratorio: muestra.laboratorio ? muestra.laboratorio.nombre.upcase : nil,
      resultado: muestra.resultado_value.upcase,
      tipo: muestra.sismuestra_tipoprueba,
      fecha: muestra.fecha ? muestra.fecha.strftime("%Y/%m/%d") : "",
      fecha_procesamiento: muestra.sismuestra_fecha_resultado ? muestra.sismuestra_fecha_resultado.strftime("%Y/%m/%d") : "",
      fecha_creacion: muestra.created_at.strftime("%Y/%m/%d %I:%M:%S%p"),
      fecha_descarga: "Generado a través de SemCovid: #{Time.now.strftime("%Y/%m/%d %I:%M:%S%p")}",
      observaciones:muestra.observaciones
    }

    #pdftk = PdfForms.new("/usr/local/bin/pdftk") #LOCALHOST
    pdftk = PdfForms.new("#{Rails.root}/vendor/pdftk/bin/pdftk") #HEROKU
    new_file_path = "#{Rails.root}/tmp/pdfs/#{SecureRandom.uuid}.pdf"
    if !params[:municipio_id].nil?
      if params[:municipio_id] == "27" 
        model_path = "scripts/modelo_sismuestra_cartagena.pdf"
      elsif params[:municipio_id] == "1996"
        model_path = "scripts/modelo_sismuestra_san_andres.pdf"
      elsif params[:municipio_id] == "4"
        model_path = "scripts/modelo_sismuestra_barranquilla.pdf"
      elsif params[:municipio_id] == "1988"
        model_path = "scripts/modelo_sismuestra_atlantico.pdf"
      else
        model_path = "scripts/modelo_sismuestra_barranquilla.pdf"
      end
    else
      if caso.municipio.id == 27 
        model_path = "scripts/modelo_sismuestra_cartagena.pdf"
      elsif caso.municipio.id == 1996
        model_path = "scripts/modelo_sismuestra_san_andres.pdf"
      elsif caso.municipio.id == 4
        model_path = "scripts/modelo_sismuestra_barranquilla.pdf"
      elsif caso.municipio.id == 1988
        model_path = "scripts/modelo_sismuestra_atlantico.pdf"
      else
        model_path = "scripts/modelo_sismuestra_barranquilla.pdf"
      end
    end
    pdftk.fill_form model_path, new_file_path, data, flatten: true
    send_file new_file_path
  end
end
