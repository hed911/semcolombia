class TheFileUploader < CarrierWave::Uploader::Base
  storage :postgresql_lo
end
