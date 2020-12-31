class Attachment < ActiveRecord::Base
  belongs_to :sample, optional:true
  belongs_to :pdf_batch, optional:true
  has_many :pdf_records

  validates :full_name, presence: true

  after_create{ |a| a.update_attribute(:uuid, SecureRandom.uuid) }
end
