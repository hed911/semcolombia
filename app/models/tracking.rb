class Tracking < ActiveRecord::Base
  include Common
  
  self.table_name = 'trackings'
  belongs_to :event, optional:true
  belongs_to :user, optional:true

  def user_type
    if user.institution
      "IPS"
    elsif usuuserario.health_entity
      "EAPB"
    else
      "CRUE"
    end
  end
end
