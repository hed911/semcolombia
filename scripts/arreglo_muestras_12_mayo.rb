cumpleano = Time.now - 4.days
laboratorio = Laboratorio.find(3)
Muestra.where(laboratorio:laboratorio, fecha_despacho_interna:cumpleano.beginning_of_day..cumpleano.end_of_day).each do |muestra|
  caso = muestra.caso_salud_publica
  next if caso.nil?
  puts "#{caso.numero_documento}"
  muestra.resultado = 1
  muestra.estado = 3
  muestra.archivos = []
  muestra.publico = false
  muestra.save!
end
