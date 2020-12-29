class Locality < ActiveRecord::Base
  self.table_name = 'localities'
  has_many :neighborhoods
end
