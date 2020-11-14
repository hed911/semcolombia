class Consulta < ActiveRecord::Base
  self.table_name = 'consultas'
  #attr_accessible :institucion, :fecha
  belongs_to :caso_salud_publica, optional:true
  belongs_to :usuario, optional:true

  def created_at_formatted
    created_at.strftime('%e %b %Y %I:%m:%S%p')
  end
end
