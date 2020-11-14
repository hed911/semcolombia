CasoSaludPublica.where(municipio: Municipio.find(22)).each do |caso|
  last_muestra = caso.muestras.order("fecha_realizacion DESC").first
  if last_muestra && (last_muestra.resultado == 2 || last_muestra.resultado == 3)
    caso.estado_enfermedad = last_muestra.resultado
    caso.save!
  end
end
