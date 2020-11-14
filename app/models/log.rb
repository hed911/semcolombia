class Log < ActiveRecord::Base
  self.table_name = 'logs'
  #attr_accessible :descripcion, :data
  belongs_to :ambulancia, optional:true
  belongs_to :eventos_ambulatorio, optional:true
end
