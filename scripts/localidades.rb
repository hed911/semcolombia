require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'barrios_localidades.xls'
sheet1 = book.worksheet 0
barranquilla = Municipio.find(4)
sheet1.each do |r|
  nombre_barrio_row               = r[1]
  nombre_localidad_row            = r[2]
  localidad_id_row                = r[6]
  barrio_id_row                   = r[7]
  puts "#{nombre_barrio_row} #{nombre_localidad_row} #{localidad_id_row} #{barrio_id_row}"
  barrio = Barrio.where(municipio:barranquilla).where("unaccent(nombre) ILIKE '%#{nombre_barrio_row}%'").first
  if barrio
    barrio.internal_id = barrio_id_row
    barrio.save!
    localidad = Localidad.find_by_nombre(nombre_localidad_row.capitalize)
    if localidad.nil?
      localidad = Localidad.create!(
        nombre:nombre_localidad_row.capitalize,
        internal_id:localidad_id_row
      )
    end
    localidad.barrios << barrio

  end
end
