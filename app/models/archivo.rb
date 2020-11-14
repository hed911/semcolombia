class Archivo < ActiveRecord::Base
  #attr_accessible :full_name
  belongs_to :muestra, optional:true
  belongs_to :cargue_masivo_pdf, optional:true
  has_many :registro_pdfs
  after_create do |archivo|
    archivo.uuid = SecureRandom.uuid
    archivo.save!
  end

end
