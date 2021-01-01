class DiagnosticsController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def index
    @diagnostics = Diagnostic.where 'nombre LIKE ? OR codigo ILIKE ?', "%#{params[:term]}%", "%#{params[:term]}%"
    respond_to do |format|
      format.json { render json: array_json(@diagnostics) }
    end
  end

end
