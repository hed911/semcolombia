class ApiUser < ApplicationRecord
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  belongs_to :department, optional:true
  belongs_to :city, optional:true
end