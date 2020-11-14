# encoding: UTF-8

class NotificacionEmergentesController < ApplicationController
  before_action :authenticate_usuario!

  def index

  end

  def search
    @notificacions = NotificacionEmergente.where(municipio:current_municipio).order('created_at DESC').paginate(page: params[:index].to_i, per_page: params[:size].to_i)
    @cantidad_paginas = @notificacions.total_pages
    render layout: false
  end

end
