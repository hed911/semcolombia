class Crue::AseguradorasController < ApplicationController
  require 'net/http'
  before_action :authenticate_usuario!

  def index
    @aseguradoras = Aseguradora.all.order('created_at ASC')
  end

  def new; end

  def create
    aseguradora = Aseguradora.create!(
      codigo: params[:codigo],
      nombre: params[:nombre]
    )
    redirect_to action: 'index'
  end

  def show; end

  def edit
    @aseguradora = Aseguradora.find(params[:id])
  end

  def update
    aseguradora = Aseguradora.find(params[:id])
    aseguradora.codigo = params[:codigo]
    aseguradora.nombre = params[:nombre]
    aseguradora.save!
    redirect_to action: 'index'
  end

  def destroy
    aseguradora = Aseguradora.find(params[:id])
    aseguradora.destroy
    redirect_to action: 'index'
  end

  def export_xls
    aseguradoras = Aseguradora.all.order('created_at DESC')
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: 'Datos') do |sheet|
      p.workbook.styles do |s|
        title_style =  s.add_style bg_color: '333333', fg_color: 'FFFFFF', sz: 11, alignment: { horizontal: :center }
        normal_style = s.add_style alignment: { horizontal: :center }

        sheet.add_row ['Nombre'], style: title_style
        for aseguradora in aseguradoras
          sheet.add_row [aseguradora.nombre], style: normal_style
        end
      end
    end
    p.use_shared_strings = true
    send_data p.to_stream.read, filename: "aseguradoras-#{Time.now.strftime('%I:%M:%S%p %d-%m-%Y')}.xls"
  end
end
