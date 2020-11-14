# encoding: UTF-8

class MunicipiosController < ApplicationController
  require 'net/http'
  before_action :authenticate_usuario!

  def get_barrios
    @component_id = params[:component_id]
    @component_id = "barrios_select" if @component_id == nil || @component_id == ""
    hash = {}
    municipio = Municipio.find params[:id]
    @barrios = municipio.barrios.where(hash).order('created_at ASC')
  end

  def show
    @municipio = Municipio.find_by_id(params[:id])
    @usuarios = Usuario.where municipio: @municipio
    @usuarios = @usuarios.order('created_at DESC')
    @zonas_json = zonas_by_municipio_json @municipio
    @selected_city_point = Geocoder.coordinates("#{@municipio.nombre} Colombia")
    @selected_city_point = [11.0041072, -74.8069813] if @selected_city_point.nil?
  end

  def set
    session[:municipio_id] = params[:id]
    redirect_back fallback_location: root_path
  end

  def update_zonas
    @municipio = Municipio.find_by_id params[:id]
    @municipio.zonas.each do |zona|
      zona.puntos.each(&:destroy!)
      zona.destroy!
    end
    items = params[:zonas].nil? ? [] : JSON.parse(params[:zonas])
    items.each do |zonas_list|
      zona = Zona.create!
      zonas_list.each do |point|
        punto = Punto.create! latitude: point[1], longitude: point[0]
        punto.zona = zona
        punto.save!
      end
      zona.municipio = @municipio
      zona.save!
    end

    @municipio = Municipio.find_by_id params[:id]
    @municipio.zonas_geo = @municipio.sql_postgis
    @municipio.save!
    @zonas_json = zonas_by_municipio_json @municipio
  end

  def toggle_habilitacion_remision
    municipio = Municipio.find_by_id params[:id]
    municipio.habilitado_remisiones = !municipio.habilitado_remisiones
    municipio.save!
    redirect_to municipio_path(municipio.id)
  end

  def toggle_habilitacion_autorizacion
    municipio = Municipio.find_by_id params[:id]
    municipio.habilitado_autorizaciones = !municipio.habilitado_autorizaciones
    municipio.save!
    redirect_to municipio_path(municipio.id)
  end

  private

  def zonas_by_municipio_json(municipio)
    result = Jbuilder.encode do |json|
      json.array! municipio.zonas do |zona|
        json.call(zona, :id)
        json.puntos do |json|
          json.array! zona.puntos.map { |p| [p.latitude, p.longitude] }
        end
      end
    end
    result
  end
end
