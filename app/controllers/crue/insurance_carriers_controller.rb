class Crue::InsuranceCarriersController < ApplicationController
  require 'net/http'
  before_action :authenticate_usuario!
  before_action :set_model, only: [:edit, :update]
  respond_to :html, :json

  def index
    @insurance_carriers = InsuranceCarrier.all.order('created_at ASC')
  end

  def new
    @insurance_carrier = InsuranceCarrier.new
  end

  def create
    @insurance_carrier = InsuranceCarrier.new(insurance_carrier_params)
    if @insurance_carrier_params.valid?
      @insurance_carrier_params.save!
      redirect_to action: 'index'
    else
      respond_with(@insurance_carrier_params)
    end
  end

  def show; end

  def edit
    @insurance_carrier = InsuranceCarrier.find(params[:id])
  end

  def update
    insurance_carrier = InsuranceCarrier.find(params[:id])
    insurance_carrier.codigo = params[:codigo]
    insurance_carrier.nombre = params[:nombre]
    insurance_carrier.save!
    redirect_to action: 'index'
  end

  def destroy
    insurance_carrier = InsuranceCarrier.find(params[:id])
    insurance_carrier.destroy
    redirect_to action: 'index'
  end
  
  private
    
  def set_model
    @insurance_carrier = InsuranceCarrier.find(params[:id])
  end 

  def insurance_carrier_params
    params.require(:insurance_carrier).permit(:codigo, :nombre)
  end
end
