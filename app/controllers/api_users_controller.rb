class ApiUsersController < ApplicationController #REVISADO
  require 'net/http'
  before_action :authenticate_user!

  def index
    @users = ApiUser.all.order('id ASC')
    @departments = Department.all.order('name ASC')
    @cities = []
  end

  def new
    @departments = Department.all.order('name ASC')
    @cities = []
    @api_user = ApiUser.new
  end

  def create
    token = Digest::SHA1.hexdigest([Time.now, rand].join).upcase
    @api_user = ApiUser.new(api_user_params)
    @api_user.password = token
    if @api_user.valid?
      @api_user.save!
      redirect_to action: 'index'
    else
      respond_with(@api_user)
    end
    redirect_to action: 'index'
  end

  def edit
    @departaments = Departamento.all.order('name ASC')
    @cities = @api_user.department.nil? ? [] : @api_user.department.cities.order('name ASC')
  end

  def update
    begin 
      @api_user.update!(api_user_params)
      redirect_to action: 'index'
    rescue => e
      @api_user.errors.add(:base, e.message)
      respond_with(@api_user)
    end
  end

  def destroy
    redirect_to action: 'index'
  end

  private
    
  def set_model
    @api_user = ApiUser.find(params[:id])
  end 

  def api_user_params
    params.require(:api_user).permit(
      :name,
      :username, 
      :password,
      :version,
      :department_id,
      :city_id
    )
  end
end