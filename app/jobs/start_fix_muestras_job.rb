require "resque-lock-timeout"
include SisMuestraHelper

class StartFixMuestrasJob
  extend Resque::Plugins::LockTimeout
  @queue = :default
  @loner = true
  def self.perform()
    CasoSaludPublica.includes(:muestras).where.not(muestras: { caso_salud_publica_id: nil }).each do |caso|
      caso.muestras.where(especial: [false, nil]).each do |muestra|
        caso.muestras.where(especial: true).each do |muestra_|
          if muestra.fecha == muestra_.fecha && muestra.laboratorio == muestra_.laboratorio
            muestra_.destroy!
          end
        end
      end
    end
  end
end
