class Intension < ActiveRecord::Base
  self.table_name = 'intention'
  belongs_to :city, optional:true
  has_many :calls
end
