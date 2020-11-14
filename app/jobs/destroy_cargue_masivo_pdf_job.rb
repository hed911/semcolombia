require 'resque-lock-timeout'
class DestroyCargueMasivoPdfJob
  extend Resque::Plugins::LockTimeout
  @queue = :default
  @loner = true
  def self.perform(id)
    cargue_masivo = CargueMasivoPdf.find_by_id id
    cargue_masivo.archivos.each do |archivo|
      archivo.destroy!
    end
    cargue_masivo.destroy!
  end
end
