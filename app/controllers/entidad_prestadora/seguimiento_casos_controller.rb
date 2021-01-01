class EntidadPrestadora::SeguimientoCasosController < ApplicationController
  require 'net/http'
  before_action :authenticate_user!

  def index
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    contacto = Contacto.where(son:@caso).first
    @parent = contacto.parent if contacto
    render(template:"/crue/seguimiento_casos/error", layout:false) if @caso.touched_by != current_usuario && @caso.touched_at && TimeDifference.between(@caso.touched_at, Time.now).in_minutes < TIMEOUT_VISUALIZAR_SEGUIMIENTOS
    if @caso.touched_at.nil? || TimeDifference.between(@caso.touched_at, Time.now).in_minutes > TIMEOUT_VISUALIZAR_SEGUIMIENTOS
      @caso.touched_at = Time.now
      @caso.touched_by = current_usuario
      @caso.save!
    end
  end

  def new
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
  end

  def create
    @caso = CasoSaludPublica.find params[:caso_salud_publica_id]
    @caso.estado_seguimiento = params[:estado]
    if @caso.estado_seguimiento == 4 || @caso.estado_seguimiento == 7
      @caso.estado = ESTADO_SP_CERRADO
    end
    @caso.usuario_seguimiento = current_usuario
    @caso.save!

    @seguimiento = SeguimientoCaso.create!(contenido: params[:contenido])
    @seguimiento.asintomatico            = params[:asintomatico] == "1"
    @seguimiento.temperatura             = params[:temperatura] == "1"
    @seguimiento.tos                     = params[:tos] == "1"
    @seguimiento.dificultad_respiratoria = params[:dificultad_respiratoria] == "1"
    @seguimiento.odinofagia              = params[:odinofagia] == "1"
    @seguimiento.fatiga                  = params[:fatiga] == "1"
    @seguimiento.contenido               = params[:contenido]
    @seguimiento.llamada_fallida         = params[:llamada_fallida] == "1"
    @seguimiento.caso_salud_publica = @caso
    @seguimiento.usuario = current_usuario
    @seguimiento.save!
  end

  def show; end

  def edit
    @caso = CasoSaludPublica.find(params[:caso_deportivo_id])
    @seguimiento = SeguimientoCaso.find(params[:id])
  end

  def update; end

  def destroy; end

end
