class Crue::IntensionsController < ApplicationController #REVISADO
  require 'net/http'
  before_action :authenticate_user!

  def index
    @intensions = Intension.where(municipio:current_municipio).order('nombre ASC')
  end

  def new; end

  def create
    intension = Intension.create!(
      nombre: params[:nombre],
      crea_casos:false
    )
    intension.municipio = current_municipio
    intension.save!
    redirect_to action: 'index'
  end

  def show; end

  def edit
    @intension = Intension.find(params[:id])
  end

  def update
    intension = Intension.find(params[:id])
    intension.nombre = params[:nombre]
    intension.crea_casos = params[:crea_casos]
    intension.save!
    redirect_to action: 'index'
  end

  def destroy
    intension = Intension.find(params[:id])
    intension.destroy
    redirect_to action: 'index'
  end

end
