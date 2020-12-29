class Department < ActiveRecord::Base
  self.table_name = 'departments'

  has_many :cities
  has_many :users

  def table_class
    if cities.none? && users.none?
      'danger'
    else
      'success'
    end
  end
end
