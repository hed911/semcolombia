CasoSaludPublica.where("observacion ILIKE '%\n%' OR observacion ILIKE '%\r%' OR observacion ILIKE '%;%'").each do  |x|
  x.observacion = x.observacion.tr("\n","").tr("\r","").tr(";",',')
  x.save!
end
Muestra.where("observaciones ILIKE '%\n%' OR observaciones ILIKE '%\r%' OR observaciones ILIKE '%;%'").each do  |x|
  x.observaciones = x.observaciones.tr("\n","").tr("\r","").tr(";",',')
  x.save!
end
