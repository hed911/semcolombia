class Contacto < ActiveRecord::Base
  self.table_name = 'contactos'
  #attr_accessible :parentezco
  belongs_to :parent, class_name: 'CasoSaludPublica', foreign_key: 'parent_id', optional:true
  belongs_to :son, class_name: 'CasoSaludPublica', foreign_key: 'son_id', optional:true

  def tipo_contacto_value
    if tipo_contacto == 1
      "Familiares"
    elsif tipo_contacto == 2
      "De vuelo"
    elsif tipo_contacto == 3
      "Personal de salud o IPS"
    elsif tipo_contacto == 4
      "Sala de espera"
    elsif tipo_contacto == 5
      "Sociales"
    end
  end

end
