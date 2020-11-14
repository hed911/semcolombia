class UsuarioApisController < ApplicationController #REVISADO
  require 'net/http'
  before_action :authenticate_usuario!

  def index
    @usuarios = UsuarioApi.all.order('id ASC')
    @departamentos = Departamento.all.order('nombre ASC')
    @municipios = []
  end

  def new
    @departamentos = Departamento.all.order('nombre ASC')
    @municipios = []
  end

  def create
    token = Digest::SHA1.hexdigest([Time.now, rand].join).upcase
    usuario_api = UsuarioApi.create!(
      nombre: params[:nombre],
      username: token,
      password: token,
      version: params[:version]
    )
    usuario_api.departamento = Departamento.find_by_id(params[:departamento_id])
    usuario_api.municipio = Municipio.find_by_id(params[:municipio_id])
    usuario_api.save!
    redirect_to action: 'index'
  end

  def edit
    @usuario = UsuarioApi.find(params[:id])
    @departamentos = Departamento.all.order('nombre ASC')
    @municipios = @usuario.departamento.nil? ? [] : @usuario.departamento.municipios.order('nombre ASC')
  end

  def update
    usuario_api = UsuarioApi.find(params[:id])
    usuario_api.nombre = params[:nombre]
    usuario_api.departamento = Departamento.find_by_id(params[:departamento_id])
    usuario_api.municipio = Municipio.find_by_id(params[:municipio_id])
    usuario_api.version = params[:version]
    usuario_api.save!
    redirect_to action: 'index'
  end

  def destroy
    usuario_api = UsuarioApi.find(params[:id])
    usuario_api.destroy
    redirect_to action: 'index'
  end
end
