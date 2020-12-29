class Device < ActiveRecord::Base
  self.table_name = 'devices'
  
  def expired_token?
    Time.now >= expiration_date
  end
end
