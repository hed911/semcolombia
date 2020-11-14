class Reunion < ActiveRecord::Base
  self.table_name = 'reunions'
  #attr_accessible :fecha, :titulo, :descripcion, :zoom_uuid, :zoom_id, :zoom_host_id, :zoom_start_url
  belongs_to :caso_salud_publica, optional:true
  belongs_to :usuario, optional:true
  belongs_to :medico, class_name: 'Usuario', foreign_key: 'medico_id', optional:true
end
