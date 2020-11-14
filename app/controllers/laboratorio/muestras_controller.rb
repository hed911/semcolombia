class Laboratorio::MuestrasController < ApplicationController
  require 'net/http'
  before_action :authenticate_usuario!
  include PdfValidationHelper

  def index
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    contacto = Contacto.where(son:@caso).first
    @parent = contacto.parent if contacto
    render layout:false
  end

  def new
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
  end

  def create
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @muestra = Muestra.create! resultado:1, estado:1
    @muestra.fecha                   = params[:fecha]
    @muestra.tipo                    = params[:tipo]
    @muestra.otro_tipo               = params[:otro_tipo]
    @muestra.caso_salud_publica      = @caso
    @muestra.emisor                  = current_usuario
    @muestra.institucion             = @caso.institucion if @caso
    @muestra.save!
    @caso.generate_indexes
  end

  def edit
    @muestra = Muestra.find params[:id]
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
  end

  def update
    @muestra = Muestra.find params[:id]
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @muestra.resultado                = params[:resultado]
    @muestra.save!
    archivo = params[:archivo]
    if archivo
      begin
        PdfValidationHelper.generate_results(@muestra, archivo)
      rescue => e
        puts "ERROR DE VALIDACION DE ARCHIVO #{e.message}"
      end
      extension =  File.extname(archivo.original_filename)
      folder_path = "soportes/#{Time.now.year}/#{Time.now.month}"
      new_name = File.basename("#{SecureRandom.uuid}#{extension}")
      new_name = "#{folder_path}/#{new_name}"
      session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", "config_drive.json"))
      session.upload_from_file(archivo.path, new_name, convert: false)
      archivo_model = Archivo.create! full_name: new_name, real_name:archivo.original_filename
      archivo_model.save!
      @muestra.archivos = [archivo_model]
    end
    @muestra.save!
  end

  def show
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @muestra = Muestra.find params[:id]
    render layout:false
  end

  def destroy
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @muestra = Muestra.find params[:id]
    @muestra.destroy
    @caso.generate_indexes
  end

  def cerrar
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @muestra = Muestra.find params[:id]
    render layout:false
  end

  def do_cerrar
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @muestra = Muestra.find params[:id]
    @muestra.codigo = params[:codigo]
    @muestra.prueba = params[:prueba]
    #@muestra.metodo_utilizado = params[:metodo_utilizado]
    #@muestra.objeto_prueba = params[:objeto_prueba]
    @muestra.resultado = params[:resultado]
    @muestra.publico = false
    #@muestra.temperatura = params[:temperatura]
    #@muestra.codigo_analista = params[:codigo_analista]
    #@muestra.codigo_responsable_tecnico = params[:codigo_responsable_tecnico]
    @muestra.observaciones = params[:observaciones].tr('<', '').tr('>','').tr('"','').tr("\r",'').tr("\n",'').tr(";",',') if params[:observaciones]
    @muestra.finalizador =  current_usuario
    @muestra.laboratorio =  current_usuario.laboratorio
    @muestra.fecha_realizacion = Time.now
    # VALIDAMOS QUE SOLO SE LE ASIGNE RESULTADO CUANDO ES 2(POSITIVO) 3(NEGATIVO)
    if params[:resultado] != "4"
      if @caso.estado_enfermedad == 2 && params[:resultado] == "3"
        @caso.estado_enfermedad = 4
      else
        @caso.estado_enfermedad = params[:resultado]
      end
      @caso.fecha_actualizacion_estado_enfermedad = Time.now
      if @caso.ha_estado_infectado && (@caso.estado_enfermedad == 3 || @caso.estado_enfermedad == 4) && params[:resultado] == "2"
        @caso.reinfeccion = true
      end
    end
    if @caso.estado_enfermedad == 2
      @caso.ha_estado_infectado = true
    end
    @muestra.estado = 5
    @muestra.fecha_procesado_interna = Time.now
    @caso.publico = false
    @caso.save!
    if @muestra.resultado == 2
      RemisionMailer.new_caso(
        @muestra,
        EMAILS_NOTIFICACION_COVID
      ).deliver
    end
    archivo = params[:archivo]
    if archivo
      begin
        PdfValidationHelper.generate_results(@muestra, archivo)
      rescue => e
        puts "ERROR DE VALIDACION DE ARCHIVO #{e.message}"
      end
      extension =  File.extname(archivo.original_filename)
      folder_path = "soportes/#{Time.now.year}/#{Time.now.month}"
      new_name = File.basename("#{SecureRandom.uuid}#{extension}")
      new_name = "#{folder_path}/#{new_name}"
      session = GoogleDrive::Session.from_service_account_key(File.join(Rails.root, "config", "config_drive.json"))
      session.upload_from_file(archivo.path, new_name, convert: false)
      archivo_model = Archivo.create! full_name: new_name, real_name:archivo.original_filename
      archivo_model.save!
      @muestra.archivos = [archivo_model]
    end
    @muestra.save!
  end

end
