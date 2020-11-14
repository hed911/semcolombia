class Api::AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login
  require 'json_web_token'

  # POST /auth/login
  def login
    @usuario = UsuarioApi.find_by_username(params[:token])
    if @usuario&.authenticate(params[:token])
      token = JsonWebToken.encode(user_id: @usuario.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     username: @usuario.username }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

end
