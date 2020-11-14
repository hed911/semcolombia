class Device < ActiveRecord::Base
  self.table_name = 'devices'
  #attr_accessible :nombre, :token, :refresh_token, :expiration_date, :provider, :renovado, :apid
  belongs_to :ambulancia, optional:true
  belongs_to :tripulante, optional:true
  belongs_to :primer_respondiente, optional:true
  def expired_token?
    Time.now >= expiration_date
  end
end
