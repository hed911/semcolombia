require "spreadsheet"
Spreadsheet.client_encoding = "UTF-8"
book = Spreadsheet.open "barrios.xls"
sheet1 = book.worksheet 0
municipio = Municipio.find 22
sheet1.each do |r|
  barrio = Barrio.where(municipio: municipio, nombre: r[0]).first
  next if !barrio.nil?
  barrio = Barrio.create! nombre: r[0]
  barrio.municipio = municipio
  barrio.save!
end
