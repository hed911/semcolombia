class DashboardController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!, except:[:consulta, :do_consulta, :consulta_barranquilla, :consulta_soledad, :do_consulta_soledad, :do_consulta_barranquilla, :consulta_cartagena, :do_consulta_cartagena, :consulta_monteria, :do_consulta_monteria, :consulta_atlantico, :do_consulta_atlantico]

  def index
    @start_date = params[:start_date]
    @end_date = params[:end_date]
  end

  def profile; end

  def set_institucion
    session[:institucion_id] = params[:id]
    redirect_back fallback_location: root_path
  end

  def consulta
    @muestras = []
  end

  def do_consulta
    if verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentar"
      @muestras = []
    end
    render 'consulta'
  end

  def consulta_barranquilla
    @muestras = []
  end

  def do_consulta_barranquilla
    if verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.municipio_id'] = [4, 1988]
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        #hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentar"
      @muestras = []
    end
    render 'consulta_barranquilla'
  end

  def consulta_soledad
    @muestras = []
  end

  def do_consulta_soledad
    if verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.municipio_id'] = 22
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentar"
      @muestras = []
    end
    render 'consulta_soledad'
  end

  def consulta_cartagena
    @muestras = []
  end

  def do_consulta_cartagena
    if verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.municipio_id'] = 27
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentar"
      @muestras = []
    end
    render 'consulta_cartagena'
  end

  def consulta_monteria
    @muestras = []
  end

  def do_consulta_monteria
    if verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.municipio_id'] = 1427
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentar"
      @muestras = []
    end
    render 'consulta_monteria'
  end

  def consulta_atlantico
    @muestras = []
  end

  def do_consulta_atlantico
    if Rails.env.development? || verify_recaptcha
      @buscando_resultados = true
      if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash_caso = {}
        hash_caso['caso_salud_publicas.municipio_id'] = [4, 1988]
        hash_caso['caso_salud_publicas.numero_documento'] = params[:numero_documento].strip if !params[:numero_documento].nil? && !params[:numero_documento].empty?
        hash = {}
        start_date = DateTime.strptime("#{params[:mes]}-01",'%Y-%m-%d') if !params[:mes].nil? && !params[:mes].empty?
        end_date = start_date.end_of_month if !params[:mes].nil? && !params[:mes].empty?
        hash[:fecha] = start_date..end_date if !params[:mes].nil? && !params[:mes].empty?
        #hash_caso['caso_salud_publicas.tipo_documento'] = params[:tipo_documento] if !params[:tipo_documento].nil? && !params[:tipo_documento].empty?
        #hash_caso['caso_salud_publicas.fecha_nacimiento'] = params[:fecha_nacimiento] if !params[:fecha_nacimiento].nil? && !params[:fecha_nacimiento].empty?
        @muestras = Muestra.where(hash).where.not({resultado:2}).includes([:caso_salud_publica]).where(hash_caso)
        @muestras = @muestras.uniq{|m| m.fecha_realizacion}
      else
        @muestras = []
      end
    else
      @error = "Error de validación, porfavor vuelva a intentaro"
      @muestras = []
    end
    render 'consulta_atlantico'
  end

end

