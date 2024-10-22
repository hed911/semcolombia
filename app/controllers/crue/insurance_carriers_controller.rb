class Crue::InsuranceCarriersController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!
  before_action :set_model, only: [:edit, :update, :destroy]
  respond_to :html, :json

  def index
    @insurance_carriers = InsuranceCarrier.all.order('created_at ASC')
  end

  def new
    @insurance_carrier = InsuranceCarrier.new
  end

  def create
    @insurance_carrier = InsuranceCarrier.new(insurance_carrier_params)
    if @insurance_carrier.valid?
      @insurance_carrier.save!
      redirect_to action: 'index'
    else
      respond_with(@insurance_carrier)
    end
  end

  def show; end

  def edit
    
  end

  def update
    begin 
      @insurance_carrier.update!(insurance_carrier_params)
      redirect_to action: 'index'
    rescue => e
      @insurance_carrier.errors.add(:base, e.message)
      respond_with(@insurance_carrier)
    end
  end

  def destroy
    @insurance_carrier.destroy
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
