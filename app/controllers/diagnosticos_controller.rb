class DiagnosticsController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def index
    @diagnostics = Diagnostic.all.order('created_at DESC')
  end

  def new

  end

  def create
    diagnostic = Diagnostic.create!(
      name: params[:name],
      number_of_hours_limit: params[:number_of_hours_limit]
    )
    redirect_to action: 'index'
  end

  def show

  end

  def edit
    @diagnostic = Diagnostic.find(params[:id])
  end

  def update
    diagnostic = Diagnostic.find(params[:id])
    diagnostic.name = params[:name]
    diagnostic.number_of_hours_limit = params[:number_of_hours_limit]
    diagnostic.save!
    redirect_to action: 'index'
  end

  def destroy
    diagnostic = Diagnostic.find(params[:id])
    diagnostic.destroy
    redirect_to action: 'index'
  end

  def export_xls
    diagnostics = Diagnostic.all.order('created_at DESC')
    p = Axlsx::Package.new
    p.workbook.add_worksheet(name: 'Datos') do |sheet|
      p.workbook.styles do |s|
        title_style =  s.add_style bg_color: '333333', fg_color: 'FFFFFF', sz: 11, alignment: { horizontal: :center }
        normal_style = s.add_style alignment: { horizontal: :center }

        sheet.add_row ['Nombre'], style: title_style
        for diagnostic in diagnostics
          sheet.add_row [diagnostic.name], style: normal_style
        end
      end
    end
    p.use_shared_strings = true
    send_data p.to_stream.read, filename: "diagnostics-#{Time.now.strftime('%I:%M:%S%p %d-%m-%Y')}.xls"
  end

  def fetch
    @diagnostics = Diagnostic.where 'nombre LIKE ? OR codigo ILIKE ?', "%#{params[:term]}%", "%#{params[:term]}%"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: array_json(@diagnostics) }
    end
  end

  def array_json(diagnostics)
    result = Jbuilder.encode do |json|
      json.array! diagnostics do |diagnostic|
        json.call(
          diagnostic,
          :id
        )
        json.set! :code, (diagnostic.code ? diagnostic.code.upcase : nil)
        json.set! :name, (diagnostic.name ? diagnostic.name.upcase : nil)
      end
    end
    result
  end

end
