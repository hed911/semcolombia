class Crue::MuestrasController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

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
    @datetime_object_recepcion = @muestra.fecha_recepcion_interna
    @datetime_recepcion = @datetime_object_recepcion.strftime('%Y-%m-%dT%T') if @datetime_object_recepcion
    @datetime_object_despacho = @muestra.fecha_despacho_interna
    @datetime_despacho = @datetime_object_despacho.strftime('%Y-%m-%dT%T') if @datetime_object_despacho
    @laboratorios = Laboratorio.where(coordinacion:[nil,false], municipio:current_municipio).order('nombre ASC')
    @instituciones = Institucion.where(activo:true, municipio:current_municipio).order('nombre ASC')
  end

  def update
    if !params[:fecha_recepcion].nil? && !params[:fecha_recepcion].empty?
      @datetime_object_recepcion = params[:fecha_recepcion].length == 19 ? Time.strptime(params[:fecha_recepcion], '%Y-%m-%dT%T') : Time.strptime("#{params[:fecha_recepcion]}:00", '%Y-%m-%dT%T')
      @datetime_recepcion = @datetime_object_recepcion.strftime('%Y-%m-%dT%T')
    end
    if !params[:fecha_despacho].nil? && !params[:fecha_despacho].empty?
      @datetime_object_despacho = params[:fecha_despacho].length == 19 ? Time.strptime(params[:fecha_despacho], '%Y-%m-%dT%T') : Time.strptime("#{params[:fecha_despacho]}:00", '%Y-%m-%dT%T')
      @datetime_despacho = @datetime_object_despacho.strftime('%Y-%m-%dT%T')
    end
    @muestra = Muestra.find params[:id]
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @muestra.fecha                    = params[:fecha]
    @muestra.tipo                     = params[:tipo]
    @muestra.otro_tipo                = params[:otro_tipo]
    @muestra.estado                   = params[:estado]
    @muestra.resultado                = params[:resultado]
    @muestra.fecha_recepcion_interna  = @datetime_recepcion
    @muestra.fecha_despacho_interna   = @datetime_despacho
    @muestra.laboratorio              = Laboratorio.find_by_id(params[:laboratorio_id])
    @muestra.institucion              = Institucion.find_by_id(params[:institucion_id])
    @muestra.observaciones            = params[:observaciones]
    archivo = params[:archivo]
    if archivo
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

end
