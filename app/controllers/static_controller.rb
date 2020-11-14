class StaticController < ApplicationController

  def terminos_condiciones

  end

  def custom_change_pass
    flash[:notice] = "Error no se pudo procesar, correo ingresado no fue encontrado"
    redirect_to root_path
  end

  def manuales
    redirect_to MANUALES_URL
  end

end
