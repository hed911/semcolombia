ActiveRecord::Base.logger = nil
QUERY = <<-FOO
select * from (
  SELECT id, municipio_id, numero_documento,
  ROW_NUMBER() OVER(PARTITION BY numero_documento ORDER BY id asc) AS Row
  FROM caso_salud_publicas
) dups
where 
dups.Row > 1
FOO
records_array = ActiveRecord::Base.connection.execute(QUERY)
puts "CONTADOR|ID|TIPO DOCUMENTO|NUMERO DOCUMENTO|CANT REPETIDOS|ORIGEN|SISMUESTRA"
records_array.each do |record|
  casos = CasoSaludPublica.where(municipio: Municipio.find(4), numero_documento: record["numero_documento"])
  next if casos.count <= 1
  counter = 0
  casos.each do |caso|
    counter += 1
    is_sismuestra = caso.especial || caso.usuario.nil?
    iec_realizado = !caso.fecha_actualizacion_iec.nil?
    #puts "numero_documento:#{caso.tipo_documento}#{caso.numero_documento} cantidad:#{casos.count} origen:#{is_sismuestra ? 'sismuestra' : 'manual'} iec:#{iec_realizado ? 'SI': 'NO'}"
    puts "#{counter}|#{caso.id}|#{caso.tipo_documento}|#{caso.numero_documento}|#{casos.count}|#{is_sismuestra ? "sismuestra" : "manual"}|#{iec_realizado ? "SI" : "NO"}"
  end
end
