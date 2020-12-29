class Movement < ActiveRecord::Base
  self.table_name = 'movements'

  belongs_to :event, optional:true
  belongs_to :user, optional:true
end
