class CargueMasivo < ActiveRecord::Base
  #   attr_accessible :archivo,
  #   :oid,
  #   :errores,
  #   :cantidad_registros,
  #   :ya_creadas_anteriormente,
  #   :creadas,
  #   :estado,
  #   :fecha_finalizacion,
  #   :pg,
  belongs_to :municipio, optional:true
  belongs_to :usuario, optional:true
  has_many :caso_salud_publicas
  has_many :muestras
  has_many :registros
  mount_uploader :archivo, TheFileUploader

  def estado_value
    if estado == 1
      'EN PROGRESO'
    elsif estado == 2
      'TERMINADO'
    elsif estado == 3
      'ERROR'
    end
  end

  def table_value
    if estado == 1
      ''
    elsif estado == 2
      'success'
    elsif estado == 3
      'danger'
    end
  end

end
