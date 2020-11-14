# encoding: UTF-8

class DepartamentosController < ApplicationController
  require 'net/http'
  before_action :authenticate_usuario!

  def index
    @departamentos = Departamento.all.order('created_at ASC')
  end

  def get_municipios_accidente
    hash = {}
    hash[:habilitado_remisiones] = true if params[:able_remisiones]
    hash[:habilitado_autorizaciones] = true if params[:able_autorizaciones]
    departamento = Departamento.find params[:id]
    @municipios = departamento.municipios.where(hash).order('created_at ASC')
  end

  def get_municipios
    @component_id = params[:component_id]
    @component_id = "municipios_select" if @component_id == nil || @component_id == ""
    hash = {}
    hash[:habilitado_remisiones] = true if params[:able_remisiones]
    hash[:habilitado_autorizaciones] = true if params[:able_autorizaciones]
    departamento = Departamento.find params[:id]
    @municipios = departamento.municipios.where(hash).order('created_at ASC')
  end

  def get_municipios_v2
    hash = {}
    hash[:habilitado_remisiones] = true if params[:able_remisiones]
    hash[:habilitado_autorizaciones] = true if params[:able_autorizaciones]
    departamento = Departamento.find params[:id]
    @municipios = departamento.municipios.where(hash).order('created_at ASC')
  end

  def get_municipios_v_despacho
    hash = {}
    hash[:habilitado_remisiones] = true if params[:able_remisiones]
    hash[:habilitado_autorizaciones] = true if params[:able_autorizaciones]
    departamento = Departamento.find params[:id]
    @municipios = departamento.municipios.where(hash).order('created_at ASC')
  end

  def get_municipios_v_destino
    hash = {}
    hash[:habilitado_remisiones] = true if params[:able_remisiones]
    hash[:habilitado_autorizaciones] = true if params[:able_autorizaciones]
    departamento = Departamento.find params[:id]
    @municipios = departamento.municipios.where(hash).order('created_at ASC')
  end

  def municipios
    @departamento = Departamento.find params[:id]
    @municipios = @departamento.municipios.order('created_at ASC')
  end
end
