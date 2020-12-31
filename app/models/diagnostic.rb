class Diagnostic < ActiveRecord::Base
  self.table_name = 'diagnostics'

  validates :name, presence: true
end
