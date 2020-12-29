class EmergentNotification < ActiveRecord::Base
  include Common

  self.table_name = 'emergent_notifications'

  belongs_to :city, optional:true
  belongs_to :health_entity, optional:true
  belongs_to :institution, optional:true
  belongs_to :user, optional:true

  def estado_value
    if status == 1
      'No leido'
    elsif status == 2
      'Leido'
    end
  end
  
end
