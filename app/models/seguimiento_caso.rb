class SeguimientoCaso < ActiveRecord::Base
  self.table_name = 'seguimiento_casos'
  #attr_accessible :contenido
  belongs_to :caso_salud_publica, optional:true
  belongs_to :usuario, optional:true

  def created_at_formatted
    created_at.strftime('%e %b %Y %I:%m:%S%p')
  end

  def tipo_usuario
    if usuario.institucion
      "IPS"
    elsif usuario.entidad_prestadora
      "EAPB"
    else
      "CRUE"
    end
  end
end
