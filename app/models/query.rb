class Query < ActiveRecord::Base
  include Common

  self.table_name = 'queries'

  belongs_to :event, optional:true
  belongs_to :usuario, optional:true
end
