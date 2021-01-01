class Crue::OperariosController < ApplicationController #REVISADO
  require 'net/http'
  before_action :authenticate_user!

  def habilitados
    operarios_ = Operario.where.not(latitude: nil, longitude: nil).order('id ASC')
    operarios = operarios_.select { |o| o.updated_position_at && TimeDifference.between(o.updated_position_at, Time.now).in_minutes <= 20 }
    respond_to do |format|
      format.json do
        result = Jbuilder.encode do |json|
          json.array! operarios do |operario|
            json.call(
              operario,
              :id,
              :nombre,
              :latitude,
              :longitude,
              :updated_position_at_formatted
            )
          end
        end
        render json: result
      end
    end
  end

  def index
    @operarios = Operario.all.order('created_at ASC')
  end

  def new; end

  def create
    operario = Operario.new(
      email: params[:email],
      cedula: params[:cedula],
      nombre: params[:nombre],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
    operario.save!
    redirect_to action: 'index'
  end

  def show
    @operario = Operario.find(params[:id])
  end

  def edit
    @operario = Operario.find(params[:id])
  end

  def update
    operario = Operario.find(params[:id])
    operario.email = params[:email]
    operario.cedula = params[:cedula]
    operario.nombre = params[:nombre]
    operario.save!
    redirect_to action: 'index'
  end

  def destroy
    operario = Operario.find(params[:id])
    operario.destroy
    redirect_to action: 'index'
  end

  def export_xls
    operarios = Operario.all.order('created_at DESC')
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: 'Datos') do |sheet|
      p.workbook.styles do |s|
        title_style =  s.add_style bg_color: '333333', fg_color: 'FFFFFF', sz: 11, alignment: { horizontal: :center }
        normal_style = s.add_style alignment: { horizontal: :center }

        sheet.add_row ['Nombre', 'Direccion', 'Descripcion', 'Latitude', 'Longitude'], style: title_style
        for operario in operarios
          sheet.add_row [operario.nombre, operario.cedula, operario.cedula], style: normal_style
        end
      end
    end
    p.use_shared_strings = true
    send_data p.to_stream.read, filename: "operarios-#{Time.now.strftime('%I:%M:%S%p %d-%m-%Y')}.xls"
  end

  def search_positions
    start_date = Time.strptime(params[:start_date], '%Y-%m-%dT%H:%M')
    end_date = Time.strptime(params[:end_date], '%Y-%m-%dT%H:%M')
    operario = Operario.find_by_cedula(params[:cedula]) if params[:cedula] && !params[:cedula].empty?
    operario = Operario.find_by_email(params[:email]) if operario.nil? && params[:email] && !params[:email].empty?
    if operario.nil?
      render json:[].to_json
      return
    end
    posiciones = Ubicacion.where(operario:operario, created_at: start_date..end_date)
    result = Jbuilder.encode do |json|
      json.array! posiciones.each_with_index.to_a do |(posicion, index)|
        previous_element = index > 0 ? posiciones[index - 1] : nil
        json.call(posicion, :latitude, :longitude, :created_at_formatted)
      end
    end
    render json: result
  end

  def actuales
    hash = { }
    hash[:cedula] = params[:cedula] if params[:cedula] && params[:cedula] != ''
    hash[:email] = params[:email] if params[:email] && params[:email] != ''
    operarios = Operario.where(hash).order("created_at ASC").to_a
    operarios.delete_if { |u| !(u.ubicacions.any? && u.ubicacions.order("created_at ASC").last.latitude && u.ubicacions.order("created_at ASC").last.longitude) }
    respond_to do |format|
      format.json do
        result = Jbuilder.encode do |json|
          json.array! operarios do |operario|
            ubicacion = operario.ubicacions.order("created_at ASC").last
            json.call(operario, :id, :nombre, :cedula, :email)
            json.set! :latitude, ubicacion.latitude
            json.set! :longitude, ubicacion.longitude
            json.set! :ultima_ubicacion, ubicacion.created_at.strftime('%Y-%m-%d %H:%M:%S')
          end
        end
        render json: result
      end
    end
  end

  def list
    hash = {  }
    hash[:cedula] = params[:cedula] if params[:cedula] && params[:cedula] != ''
    hash[:email] = params[:email] if params[:email] && params[:email] != ''
    @operarios = Operario.where(hash).order("created_at ASC").to_a
    @operarios.delete_if { |u| !u.ubicacions.any? }
    render layout:false
  end

  def ultima_ubicacion
    @operario = Operario.find_by_id params[:id]
    @last_ubicacion = @operario.ubicacions.order("created_at ASC").last
  end

end
