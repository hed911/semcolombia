class Laboratory < ActiveRecord::Base
  self.table_name = 'laboratories'
  belongs_to :city, optional:true
  has_many :users

  validates :name presence: true
end


