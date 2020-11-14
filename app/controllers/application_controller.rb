class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  require 'json_web_token'
  protect_from_forgery with: :null_session
  alias current_user current_usuario

  helper_method :current_institucion, :can_chenge_institucion, :recently_added_new_version, :resource_name, :resource, :send_push, :current_municipio, :current_user_name, :current_city_point, :authorize_request

  before_action :set_raven_context, :set_raven_context

  def recently_added_new_version
    TimeDifference.between(Date.strptime(CURRENT_APP_DATE, '%Y/%m/%d'), Time.now).in_days <= 10
  end

  def resource_name
    :Usuario
  end

  def resource
    @usuario ||= Usuario.new
  end

  def current_user_name
    name = ''
    suffix = ''
    name = current_user.primer_nombre if current_user
    suffix = if current_user.departamento
               if current_municipio
                 "(#{current_municipio.nombre.upcase[0,1]})"
               else
                 "(#{current_user.departamento.nombre})"
               end
             elsif current_user.municipio
               "(#{current_user.municipio.nombre.upcase[0,1]})"
             else
               '(ADMIN)'
             end
    "#{name}#{suffix}"
  end

  def current_municipio
    if session[:municipio_id]
      return Municipio.find_by_id session[:municipio_id]
    else
      if current_usuario
        if !current_usuario.municipio_alterno.nil?
          return current_usuario.municipio_alterno
        elsif current_usuario.municipio.nil?
          if current_usuario.laboratorio
            return current_usuario.laboratorio.municipio
          elsif current_institucion
            return current_institucion.municipio
          end
        else
          return current_usuario.municipio
        end
      end
    end
  end

  def current_city_point
    if current_municipio
      if current_municipio.default_latitude && current_municipio.default_longitude
        [current_municipio.default_latitude, current_municipio.default_longitude]
      else
        result = Geocoder.coordinates("#{current_municipio.nombre} Colombia")
        current_municipio.default_latitude = result[0]
        current_municipio.default_longitude = result[1]
        current_municipio.save!
        result
      end
    else
      [10.9638889, -74.7963889]
    end
  end

  def can_chenge_institucion
    return false if current_usuario.nil?
    return false if current_usuario.institucion.nil?
    current_usuario.institucion.sedes.count > 1
  end

  def current_institucion
    if session[:institucion_id]
      return Institucion.find_by_id session[:institucion_id]
    else
      current_usuario.institucion
    end
  end

  private

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_usuario = UsuarioApi.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

end
