class Call < ActiveRecord::Base
  self.table_name = 'calls'
  include Common

  belongs_to :event, optional:true
  belongs_to :user, optional:true
  belongs_to :intention, optional:true
  belongs_to :department, optional:true
  belongs_to :city, optional:true

  def table_value
    caso_salud_publica.nil? ? "" : "table-warning"
  end

end
