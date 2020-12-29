class Meeting < ActiveRecord::Base
  self.table_name = 'meetings'
  belongs_to :event, optional:true
  belongs_to :user, optional:true
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id', optional:true
end
