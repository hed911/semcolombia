class Neighborhoods < ActiveRecord::Base
  self.table_name = "neighborhoods"
  belongs_to :localidad, optional: true
  belongs_to :municipio, optional: true
end
