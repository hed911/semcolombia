class ApplicationController < ActionController::Base
  require 'json_web_token'
  protect_from_forgery with: :null_session
  alias current_user current_user

  helper_method :current_institution, :can_chenge_institution, :recently_added_new_version, :resource_name, :resource, :send_push, :current_city, :current_user_name, :authorize_request

  before_action :set_raven_context, :set_raven_context

  def recently_added_new_version
    TimeDifference.between(Date.strptime(CURRENT_APP_DATE, '%Y/%m/%d'), Time.now).in_days <= 10
  end

  def resource_name
    :user
  end

  def resource
    @user ||= User.new
  end

  def current_user_name
    name = ''
    suffix = ''
    name = current_user.first_name if current_user
    suffix = if current_user.departamento
      if current_city
        "(#{current_city.nombre.upcase[0,1]})"
      else
        "(#{current_user.department.nombre})"
      end
    elsif current_user.city
      "(#{current_user.city.nombre.upcase[0,1]})"
    else
      '(ADMIN)'
    end
    "#{name}#{suffix}"
  end

  def current_city
    if session[:city]
      return City.find_by_id session[:city_id]
    else
      if current_user
        if !current_user.alternate_city.nil?
          return current_user.alternate_city
        elsif current_user.city.nil?
          if current_user.laboratory
            return current_user.laboratory.city
          elsif current_institution
            return current_institution.city
          end
        else
          return current_user.city
        end
      end
    end
  end

  def can_chenge_institution
    return false if current_user.nil?
    return false if current_user.institution.nil?
    current_user.institution.sites.count > 1
  end

  def current_institution
    if session[:institution_id]
      return Institution.find_by_id(session[:institution_id])
    else
      current_user.institution
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
      @current_user = ApiUser.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

end
