class Laboratory::TrackingsController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def index
    @statuses = [
      {id:1, name:'EN SEGUIMIENTO'},
      {id:3, name:'RESUELTO SATISFACTORIAMENTE'},
      {id:4, name:'NO CUMPLE CON DEFINICION DE CASO'},
      {id:5, name:'AISLAMIENTO EN CASA'}
    ]
    contact = Contact.where(son:@caso).first
    @parent = contact.parent if contact
    render(template:"/laboratory/trackings/error", layout:false) if @event.touched_by != current_usuario && @event.touched_at && TimeDifference.between(@event.touched_at, Time.now).in_minutes < TIMEOUT_VISUALIZAR_SEGUIMIENTOS
    if @event.touched_at.nil? || TimeDifference.between(@event.touched_at, Time.now).in_minutes > TIMEOUT_VISUALIZAR_SEGUIMIENTOS
      @event.touched_at = Time.now
      @event.touched_by = current_user
      @event.save!
    end
  end

  def new
    @tracking = Tracking.new
  end

  def create
    @event.tracking_status = params[:tracking_params][:tracking][:status]
    @event.status = ESTADO_SP_CERRADO if @event.tracking_status == 4 || @caso.tracking_status == 7
    @event.tracking_user = current_user
    @event.save!
    @errors = []
    begin
      @tracking = Tracking.create!(tracking_params)
      @tracking.event = @event
      @tracking.user = current_user
      @tracking.save!
    rescue => e
      @tracking.errors.add(:base, e.message)
      @errors = @tracking.errors
    end
  end

  private

  def set_model
    @event = Event.find params[:event_id]
  end 

  def tracking_params

    params.permit(:roles).require(:user).permit(
      :asymptomatic,
      :temperature,
      :cough,
      :respiratory_distress,
      :odynophagia,
      :fatigue,
      :observation, 
      :status, 
      :failed_call
    )
  end
end
