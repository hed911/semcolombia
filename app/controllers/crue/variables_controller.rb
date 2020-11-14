class Crue::VariablesController < ApplicationController
  require 'net/http'
  before_action :authenticate_usuario!

  def toggle_activar_nopos
    variable = Variable.find_by_tag 'new_afiliacion'
    variable.value = variable.value == 'true' ? 'false' : 'true'
    variable.save!
    redirect_to configurate_path
  end

  def sms
    @variable_sms_ok = Variable.find_by_tag 'sms_ok'
    @variable_sms_bad = Variable.find_by_tag 'sms_bad'
  end

  def update_sms
    variable_sms_ok = Variable.find_by_tag 'sms_ok'
    variable_sms_bad = Variable.find_by_tag 'sms_bad'
    variable_sms_ok.value = params[:sms_ok]
    variable_sms_bad.value = params[:sms_bad]
    variable_sms_ok.save!
    variable_sms_bad.save!
    redirect_to sms_variables_path
    flash[:notice] = 'Textos actualizados exitosamente'
  end


end
