class DiagnosticosController < ApplicationController
  require 'net/http'
  before_action :authenticate_usuario!

  def index
    @diagnosticos = Diagnostico.all.order('created_at DESC')
  end

  def new; end

  def create
    diagnostico = Diagnostico.create!(
      nombre: params[:nombre],
      cantidad_horas_limite: params[:cantidad_horas_limite]
    )
    redirect_to action: 'index'
  end

  def show; end

  def edit
    @diagnostico = Diagnostico.find(params[:id])
  end

  def update
    diagnostico = Diagnostico.find(params[:id])
    diagnostico.nombre = params[:nombre]
    diagnostico.cantidad_horas_limite = params[:cantidad_horas_limite]
    diagnostico.save!
    redirect_to action: 'index'
  end

  def destroy
    diagnostico = Diagnostico.find(params[:id])
    diagnostico.destroy
    redirect_to action: 'index'
  end

  def export_xls
    diagnosticos = Diagnostico.all.order('created_at DESC')
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: 'Datos') do |sheet|
      p.workbook.styles do |s|
        title_style =  s.add_style bg_color: '333333', fg_color: 'FFFFFF', sz: 11, alignment: { horizontal: :center }
        normal_style = s.add_style alignment: { horizontal: :center }

        sheet.add_row ['Nombre'], style: title_style
        for diagnostico in diagnosticos
          sheet.add_row [diagnostico.nombre], style: normal_style
        end
      end
    end
    p.use_shared_strings = true
    send_data p.to_stream.read, filename: "diagnosticos-#{Time.now.strftime('%I:%M:%S%p %d-%m-%Y')}.xls"
  end

  def search
    @diagnosticos = Diagnostico.where 'nombre LIKE ? OR codigo ILIKE ?', "%#{params[:term]}%", "%#{params[:term]}%"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: array_json(@diagnosticos) }
    end
  end

  def array_json(diagnosticos)
    result = Jbuilder.encode do |json|
      json.array! diagnosticos do |diagnostico|
        json.call(
          diagnostico,
          :id
        )
        json.set! :codigo, (diagnostico.codigo ? diagnostico.codigo.upcase : nil)
        json.set! :nombre, (diagnostico.nombre ? diagnostico.nombre.upcase : nil)
      end
    end
    result
  end
end
