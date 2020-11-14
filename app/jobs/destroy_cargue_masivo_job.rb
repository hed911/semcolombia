require 'resque-lock-timeout'
class DestroyCargueMasivoJob
  extend Resque::Plugins::LockTimeout
  @queue = :default
  @loner = true
  def self.perform(id)
    cargue_masivo = CargueMasivo.find_by_id id
    cargue_masivo.caso_salud_publicas.each do |item|
      item.destroy!
    end
    cargue_masivo.muestras.each do |item|
      item.destroy!
    end
    cargue_masivo.registros.each do |item|
      item.destroy!
    end
    cargue_masivo.destroy!
  end
end
