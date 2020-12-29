class Operator < ActiveRecord::Base
  self.table_name = 'operators'
  devise :database_authenticatable,
         :rememberable,
         :trackable,
         :validatable

  has_many :devices
end
