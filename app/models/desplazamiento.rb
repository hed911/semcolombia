class Desplazamiento < ActiveRecord::Base
  self.table_name = 'desplazamientos'
  #attr_accessible :contenido
  belongs_to :caso_salud_publica, optional:true
  belongs_to :usuario, optional:true

  def created_at_formatted
    created_at.strftime('%e %b %Y %I:%m:%S%p')
  end
end
