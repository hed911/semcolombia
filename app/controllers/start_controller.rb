class InicioController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def blank
    redirect_to(crue_super_admins_path) if current_usuario.es_super_admin
  end

end
