class PasswordsController < Devise::PasswordsController
  protected

  def new
    raise 'error'
  end

  def after_sending_reset_password_instructions_path_for(_resource_name)
    flash[:notice] = 'Se enviara un correo con un enlace para que cambies la contraseña'
    flash[:class] = 'success'
    root_path
  end
end
