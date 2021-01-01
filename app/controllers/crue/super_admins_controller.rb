# encoding: UTF-8

class Crue::SuperAdminsController < ApplicationController #REVISADO
  before_action :authenticate_user!

  def index
    @super_admins = Usuario.where(es_super_admin: true, institucion:nil, entidad_prestadora:nil).sort_by &:created_at
  end

  def new; end

  def create #:primer_nombre, :segundo_nombre, :primer_apellido, :segundo_apellido, :email, :password
    if params[:password_dinamica]
      password = (0...8).map { (65 + rand(26)).chr }.join.downcase
      password_confirmation = password
    else
      password = params[:password]
      password_confirmation = params[:password_confirmation]
    end
    usuario = Usuario.create!(
      primer_nombre: params[:primer_nombre],
      segundo_nombre: params[:segundo_nombre],
      primer_apellido: params[:primer_apellido],
      segundo_apellido: params[:segundo_apellido],
      telefono: params[:telefono],
      celular: params[:celular],
      email: params[:email],
      password: password,
      password_confirmation: password_confirmation,
      activo: params[:activo],
      identificacion: params[:identificacion],
      cargo: params[:cargo],
      fecha_vigencia: params[:fecha_vigencia],
      es_super_admin: true
    )
    UserMailer.create_user_instructions(
      usuario.primer_nombre,
      usuario.email,
      password,
      []
    ).deliver
    flash[:notice] = 'Admin agregado exitosamente.'
    redirect_to action: 'index'
  end

  def edit
    @super_admin = Usuario.find params[:id]
  end

  def update
    can_update = true
    usuario = Usuario.find params[:id]
    repeated_email = Usuario.find_by_email params[:email]

    can_update = false if repeated_email && usuario != repeated_email

    if can_update
      usuario.primer_nombre = params[:primer_nombre]
      usuario.segundo_nombre = params[:segundo_nombre]
      usuario.primer_apellido = params[:primer_apellido]
      usuario.segundo_apellido = params[:segundo_apellido]
      usuario.telefono = params[:telefono]
      usuario.celular = params[:celular]
      usuario.activo = params[:activo]
      usuario.identificacion = params[:identificacion]
      usuario.cargo = params[:cargo]
      usuario.fecha_vigencia = params[:fecha_vigencia]
      usuario.email = params[:email]
      usuario.save!
      flash[:notice] = 'Admin editado exitosamente.'
      redirect_to action: 'index'
    else
      flash[:notice] = 'Error,no se pudo editar correo REPETIDO.'
      redirect_to action: 'index'
    end
  end

  def destroy
    usuario = Usuario.find params[:id]
    if usuario
      usuario.destroy!
      flash[:notice] = 'Usuario crue borrado exitosamente.'
      redirect_to action: 'index'
    else
      flash[:notice] = 'Error no se pudo borrar, usuario crue no encontrado.'
      redirect_to action: 'index'
    end
  end

  def export_xls
    usuarios = Usuario.all

    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: 'Datos') do |sheet|
      p.workbook.styles do |s|
        title_style =  s.add_style bg_color: '333333', fg_color: 'FFFFFF', sz: 11, alignment: { horizontal: :center }
        normal_style = s.add_style alignment: { horizontal: :center }

        sheet.add_row [
          'Primer Nombre',
          'Segundo Nombre',
          'Primer Apellido',
          'Segundo Apellido',
          'Email',
          'Fecha de Creacion'
        ], style: title_style
        for usuario in usuarios
          sheet.add_row [
            usuario.primer_nombre,
            usuario.segundo_nombre,
            usuario.primer_apellido,
            usuario.segundo_apellido,
            usuario.email,
            usuario.created_at.strftime('%I:%M:%S%p %d-%m-%Y')
          ], style: normal_style
           end
      end
    end
    p.use_shared_strings = true
    send_data p.to_stream.read, filename: "usuarios-#{Time.now.strftime('%I:%M:%S%p %d-%m-%Y')}.xls"
  end

  def change_pass
    @usuario = Usuario.find_by_id params[:id]
  end

  def do_change_pass
    usuario = Usuario.find params[:id]
    usuario.password = params[:password]
    usuario.password_confirmation = params[:password]
    usuario.save!

    flash[:notice] = "Contraseña de #{usuario.primer_nombre} cambiada exitosamente."
    redirect_to action: 'index'
  end
end
