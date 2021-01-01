# encoding: UTF-8
class Laboratorio::UsersController < ApplicationController #ACTUALIZADA
  require 'net/http'
  before_action :authenticate_user!
  before_action :set_model

  def index
    @users = User.where(laboratorio:@laboratorio).order('created_at DESC')
  end

  def new
    render layout:false
  end

  def create    
    parsed_params = user_params
    if params[:password_dinamica]
      parsed_params[:password] = (0...8).map { (65 + rand(26)).chr }.join.downcase
      parsed_params[:password_confirmation] = parsed_params[:password]
    end
    @user = User.create!(parsed_params)
    @user.roles = parsed_params[:roles].keys.split(",")
    if @user.valid?
      @user.save!
      UserMailer.create_user_instructions(
        @user.first_name,
        @user.email,
        parsed_params[:password],
        []
      ).deliver
      flash[:notice] = 'Usuario creado exitosamente.'
    else
      respond_with(@laboratory, @user)
    end
  end

  def show; end

  def edit; end

  def update
    parsed_params = user_params
    parsed_params[:roles] = parsed_params[:roles].keys.split(",")
    begin
      @user.update!(parsed_params)
      redirect_to action: 'index'
    rescue => e
      @user.errors.add(:base, e.message)
      respond_with(@laboratory, @user)
    end
  end

  def destroy
    @user.destroy!
    flash[:notice] = 'Usuario borrado exitosamente.'
    redirect_to action: 'index'
  end

  def change_pass; end

  def do_change_pass
    user.password = params[:password]
    user.password_confirmation = params[:password]
    user.save!
    flash[:notice] = "Contrase\u00F1a actualizada exitosamente."
    redirect_to laboratory_users_path
  end

  def reset_password
    password = (0...8).map { (65 + rand(26)).chr }.join.downcase
    user.password = password
    user.password_confirmation = password
    UserMailer.create_user_instructions(
      user.primer_nombre,
      user.email,
      password,
      []
    ).deliver
    user.save!
    flash[:notice] = "Se ha enviado exitosamente informacion para el restablecimiento de la contraseña al correo #{user.email}"
    redirect_to action: 'index'
  end

  def set_model
    @laboratory = current_user.laboratory
    @user = User.find_by_id(params[:id])
  end 

  def user_params
    params.permit(:roles).require(:user).permit(
      :active, 
      :id_number,
      :position,
      :validity_date,
      :phone_number,
      :email,
      :first_name,
      :second_name,
      :first_surname,
      :second_surname,
      :password,
      :password_confirmation
    )
  end
end
