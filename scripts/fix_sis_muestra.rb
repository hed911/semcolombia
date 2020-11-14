# EN CASO DE QUE LAS MUESTRAS QUE VENGAN DE SISMUESTRA TENGAN
Muestra.where(fecha_envio: nil, estado: 3, resultado: 1).includes(:caso_salud_publica).where("caso_salud_publicas.municipio_id": 4).each do |m|
  m.destroy!
end

sismuestra fecha de recepcion y fecha de envio y tambien el usuario que recibe
ActiveRecord::Base.logger = nil
Muestra.where(fecha_recepcion_interna: nil, fecha_despacho_interna: nil, estado: 5).includes(:caso_salud_publica).where("caso_salud_publicas.municipio_id": 4).each do |x|
  caso = x.caso_salud_publica
  puts "ID:#{x.id} DOCUMENTO:#{caso.tipo_documento}#{caso.numero_documento}"
end

SELECT COUNT(*) FROM muestras; --133235
SELECT COUNT(*) FROM caso_salud_publicas; --119985

DELETE FROM muestras WHERE id IN (SELECT m.id
FROM muestras AS m
INNER JOIN caso_salud_publicas AS c
ON m.caso_salud_publica_id = c.id
WHERE m.fecha_recepcion_interna IS NULL AND m.fecha_despacho_interna IS NULL AND m.estado = 5 AND c.municipio_id = 4);