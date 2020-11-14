require "spreadsheet"
Spreadsheet.client_encoding = "UTF-8"
book = Spreadsheet.open "instituciones.xls"
sheet1 = book.worksheet 0
sheet1.each do |r|
  habi_codigo_habilitacion = r[2]
  nombre_prestador = r[3]
  numero_sede = r[5]
  sede_nombre = r[6]

  sede_nombre = "" if sede_nombre.nil?
  nombre_prestador = "" if nombre_prestador.nil?
  numero_sede = numero_sede.to_i

  institucion = Institucion.find_by_codigo_habilitacion_and_numero_sede(habi_codigo_habilitacion, numero_sede)
  if institucion.nil?
    institucion = Institucion.create!(
      especial: true,
      nombre: sede_nombre.strip.downcase,
      codigo_habilitacion: habi_codigo_habilitacion,
      numero_sede: numero_sede,
      activo: true,
      roles: "5",
    )
    institucion.municipio = Municipio.find(1988)
    parent = Institucion.where(municipio: Municipio.find(1988)).where("nombre ILIKE '%#{nombre_prestador.strip}%'").first
    if parent.nil?
      parent = Institucion.create!(
        especial: true,
        nombre: nombre_prestador.strip.downcase,
        activo: true,
        roles: "5",
      )
      parent.municipio = Municipio.find(1988)
      parent.save!
    end
    institucion.parent = parent
    institucion.save!
  end
end
