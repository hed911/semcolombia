class Country < ActiveRecord::Base
  self.table_name = 'countries'
  #attr_accessible :nombre, :codigo
end
