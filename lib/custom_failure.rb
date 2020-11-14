class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_options[:attempted_path] == root_path
      '/usuarios/sign_in'
    else
      root_path
    end
    # 'https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-when-the-user-can-not-be-authenticated'
    # root_path
  end

  def respond
    if http_auth?
      http_auth
    else
      flash[:notice] = nil#'Correo y/o contraseña invalida'
      redirect
    end
  end
end
