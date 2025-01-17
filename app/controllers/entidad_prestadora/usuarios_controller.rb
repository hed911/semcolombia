# encoding: UTF-8

class EntidadPrestadora::UsuariosController < ApplicationController #REVISADO
  require 'net/http'
  before_action :authenticate_user!

  def index
    @entidad_prestadora = current_usuario.entidad_prestadora
    @usuarios = Usuario.where(municipio:current_municipio, entidad_prestadora: @entidad_prestadora)
    @usuarios = @usuarios.order('created_at DESC')
    @departamentos = Departamento.all.order('created_at ASC')
  end

  def create
    if Usuario.find_by_email(params[:email])
      raise 'Ya existe una cuenta con este correo.'
    end
    roles = ''
    counter = 1
    if params[:roles]
      params[:roles].each do |key, _value|
        roles = if counter > 1
                  "#{roles},#{key}"
                else
                  key.to_s
                  end
        counter += 1
      end
    end
    if params[:password_dinamica]
      password = (0...8).map { (65 + rand(26)).chr }.join.downcase
      password_confirmation = password
    else
      password = params[:password]
      password_confirmation = params[:password_confirmation]
    end
    usuario = Usuario.create!(
      roles: roles,
      activo: true,
      identificacion: params[:identificacion],
      cargo: params[:cargo],
      fecha_vigencia: params[:fecha_vigencia],
      telefono: params[:telefono],
      email: params[:email],
      primer_nombre: params[:primer_nombre],
      primer_apellido: params[:primer_apellido],
      segundo_nombre: params[:segundo_nombre],
      segundo_apellido: params[:segundo_apellido],
      password: password,
      password_confirmation: password_confirmation
    )
    usuario.entidad_prestadora = current_usuario.entidad_prestadora
    if current_municipio
      usuario.departamento = current_municipio.departamento
      usuario.municipio = current_municipio
    else
      usuario.departamento = Departamento.find_by_id params[:departamento_id]
      usuario.municipio = Municipio.find_by_id params[:municipio_id]
    end
    usuario.save!
    flash[:notice] = 'Usuario creado exitosamente.'
    redirect_to entidad_prestadora_usuarios_path
  end

  def show; end

  def edit
    @entidad_prestadora = current_usuario.entidad_prestadora
    @usuario = Usuario.find_by_id(params[:id])
  end

  def update
    usuario = Usuario.find_by_id(params[:id])
    usuario.activo = params[:activo]
    usuario.identificacion = params[:identificacion]
    usuario.fecha_vigencia = params[:fecha_vigencia]
    usuario.primer_nombre = params[:primer_nombre]
    usuario.primer_apellido = params[:primer_apellido]
    usuario.segundo_nombre = params[:segundo_nombre]
    usuario.segundo_apellido = params[:segundo_apellido]
    usuario.telefono = params[:telefono]
    roles = ''
    counter = 1
    if params[:roles]
      params[:roles].each do |key, _value|
        roles = if counter > 1
                  "#{roles},#{key}"
                else
                  key.to_s
                end
        counter += 1
      end
    end
    usuario.roles = roles
    usuario.save!
    flash[:notice] = 'Datos de usuario actualizados exitosamente.'
    redirect_to entidad_prestadora_usuarios_path
  end

  def destroy
    usuario = Usuario.find_by_id(params[:id])
    usuario.destroy!
    flash[:notice] = 'Usuario borrado exitosamente.'
    redirect_to entidad_prestadora_usuarios_path
  end

  def export_xls
    usuarios = current_usuario.entidad_prestadora.usuarios
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: 'Datos') do |sheet|
      p.workbook.styles do |s|
        title_style =  s.add_style bg_color: '333333', fg_color: 'FFFFFF', sz: 11, alignment: { horizontal: :center }
        normal_style = s.add_style alignment: { horizontal: :center }

        sheet.add_row ['Nombre Completo', 'Identificacion', 'Email', 'Cargo', 'Fecha Vigencia'], style: title_style
        for usuario in usuarios
          sheet.add_row [usuario.nombre_completo, usuario.identificacion, usuario.email, usuario.cargo, (usuario.fecha_vigencia.strftime('%e %b %Y') if usuario.fecha_vigencia)], style: normal_style
           end
      end
    end
    p.use_shared_strings = true
    send_data p.to_stream.read, filename: "usuarios-#{Time.now.strftime('%I:%M:%S%p %d-%m-%Y')}.xls"
  end

  def change_pass
    @entidad_prestadora = current_usuario.entidad_prestadora
    @usuario = Usuario.find_by_id(params[:id])
  end

  def do_change_pass
    @entidad_prestadora = current_usuario.entidad_prestadora
    usuario = Usuario.find_by_id(params[:id])
    usuario.password = params[:password]
    usuario.password_confirmation = params[:password]
    usuario.save!

    flash[:notice] = "Contrase\u00F1a actualizada exitosamente."
    redirect_to entidad_prestadora_usuarios_path
  end

  def reset_password
    usuario = Usuario.find params[:id]
    password = (0...8).map { (65 + rand(26)).chr }.join.downcase
    usuario.password = password
    usuario.password_confirmation = password
    UserMailer.create_user_instructions(
      usuario.primer_nombre,
      usuario.email,
      password,
      []
    ).deliver
    usuario.save!
    flash[:notice] = "Se ha enviado exitosamente informacion para el restablecimiento de la contraseña al correo #{usuario.email}"
    redirect_to action: 'index'
  end
end
