
require 'spreadsheet'
Spreadsheet.client_encoding = 'UTF-8'
book = Spreadsheet.open 'muestras.xls'
sheet1 = book.worksheet 0
barranquilla = Municipio.find(4)
first = true
sheet1.each do |r|
  if first
    first = false
    next
  end
  numero_muestra_row              = r[0]
  tipo_documento_row              = r[5]
  numero_documento_row            = r[6]
  muestra = Muestra.find_by_codigo_archivo(numero_muestra_row)
  caso = muestra.caso_salud_publica
  if caso
    caso.numero_documento            = numero_documento_row
    caso.save!
  end
end
