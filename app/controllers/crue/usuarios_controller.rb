# encoding: UTF-8

class Crue::UsuariosController < ApplicationController #ACTUALIZADA
  before_action :authenticate_user!
  include ZoomHelper

  def index
    hash = {es_super_admin: [false, nil], institucion:nil, entidad_prestadora:nil}
    hash[:municipio] = current_municipio if !current_usuario.es_super_admin
    @usuarios = Usuario.where(hash).sort_by &:created_at
  end

  def new
    @departamentos = Departamento.all.order('nombre ASC')
    @municipios = []
  end

  def create #:primer_nombre, :segundo_nombre, :primer_apellido, :segundo_apellido, :email, :password
    if Usuario.find_by_email(params[:email])
      flash[:notice] = 'Error, ya existe un usuario con este email'
      redirect_to new_crue_usuario_path
      return
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
      primer_nombre: params[:primer_nombre],
      segundo_nombre: params[:segundo_nombre],
      primer_apellido: params[:primer_apellido],
      segundo_apellido: params[:segundo_apellido],
      telefono: params[:telefono],
      celular: params[:celular],
      email: params[:email],
      password: password,
      password_confirmation: password_confirmation,
      roles: roles,
      activo: params[:activo],
      identificacion: params[:identificacion],
      cargo: params[:cargo],
      fecha_vigencia: params[:fecha_vigencia]
    )
    if params[:municipio_id]
      usuario.municipio = Municipio.find_by_id params[:municipio_id]
    else
      usuario.municipio = current_municipio
    end
    usuario.municipio_alterno = Municipio.find_by_id params[:municipio_alterno_id]
    usuario.departamento_alterno = usuario.municipio_alterno ? usuario.municipio_alterno.departamento : nil
    usuario.save!
    UserMailer.create_user_instructions(
      usuario.primer_nombre,
      usuario.email,
      password,
      []
    ).deliver
    flash[:notice] = 'Usuario crue creado exitosamente.'
    if usuario.roles.include?("8") && usuario.zoom_id.nil?
      result = nil
      hubo_error = false
      begin
        result = ZoomHelper.create_user(usuario.primer_nombre, usuario.primer_apellido, usuario.email)
        hubo_error = result[:code] != 201
      rescue => e
        puts "ERROR CON LA API :S #{e.message}"
        hubo_error = true
      end
      if hubo_error
        usuario.zoom_id = nil
        usuario.zoom_activated = false
      else
        usuario.zoom_id      = result[:response]["id"]
        usuario.zoom_activated = false
      end
      usuario.save!
    end
    redirect_to action: 'index'
  end

  def edit
    @usuario = Usuario.find params[:id]
    @municipio = @usuario.municipio
    @departamento = @municipio.nil? ? nil : @municipio.departamento
    @departamentos = Departamento.all.order('nombre ASC')
    @municipios = @municipio.nil? ? [] : @departamento.municipios.order('nombre ASC')

    @municipio_alterno = @usuario.municipio_alterno
    @departamento_alterno = @municipio_alterno.nil? ? nil : @municipio_alterno.departamento
    @municipios_alternos = @municipio_alterno.nil? ? [] : @departamento_alterno.municipios.order('nombre ASC')
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
      if params[:municipio_id]
        usuario.municipio = Municipio.find_by_id params[:municipio_id]
      else
        usuario.municipio = current_municipio
      end
      usuario.municipio_alterno = Municipio.find_by_id params[:municipio_alterno_id]
      usuario.departamento_alterno = usuario.municipio_alterno ? usuario.municipio_alterno.departamento : nil
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
      if usuario.roles.include?("9") && usuario.zoom_id.nil?
        result = nil
        hubo_error = false
        begin
          result = ZoomHelper.create_user(usuario.primer_nombre, usuario.primer_apellido, usuario.email)
          hubo_error = result[:code] != 201
        rescue => e
          puts "ERROR CON LA API :S #{e.message}"
          hubo_error = true
        end
        if hubo_error
          usuario.zoom_id = nil
          usuario.zoom_activated = false
        else
          usuario.zoom_id      = result[:response]["id"]
          usuario.zoom_activated = false
        end
        usuario.save!
      end
      flash[:notice] = 'Usuario crue editado exitosamente.'
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

  def change_my_pass
    usuario = current_usuario
    usuario.password = params[:password]
    usuario.password_confirmation = params[:password]
    usuario.save!
    flash[:notice] = "Contraseña de #{usuario.primer_nombre} cambiada exitosamente."
    redirect_to action: 'index'
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
