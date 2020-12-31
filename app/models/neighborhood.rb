class Neighborhoods < ActiveRecord::Base
  self.table_name = "neighborhoods"
  belongs_to :locality, optional: true
  belongs_to :city, optional: true
end
