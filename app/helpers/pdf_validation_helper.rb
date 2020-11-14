module PdfValidationHelper

  def self.generate_results(muestra, archivo)
    caso = muestra.caso_salud_publica
    return if caso.nil?
    PDF::Reader.open(archivo.path) do |reader|
      puntaje = 0
      cantidad_positivos = 0
      cantidad_negativos = 0
      numero_documento_corresponde = false
      primer_nombre_corresponde = false
      segundo_nombre_corresponde = false
      primer_apellido_corresponde = false
      segundo_apellido_corresponde = false
      reader.pages.each do |page|
        text = I18n.transliterate(page.text.downcase)
        cantidad_positivos += text.scan(/positivo/).length
        cantidad_negativos += text.scan(/negativo/).length
        if !numero_documento_corresponde && caso.numero_documento
          numero_documento_corresponde = text.include?(caso.numero_documento.downcase.strip)
          puntaje += 1 if numero_documento_corresponde
        end
        if !primer_nombre_corresponde && caso.primer_nombre
          primer_nombre_corresponde = text.include?(I18n.transliterate(caso.primer_nombre.downcase.strip))
          puntaje += 1 if primer_nombre_corresponde
        end
        if !segundo_nombre_corresponde && caso.segundo_nombre
          segundo_nombre_corresponde = text.include?(I18n.transliterate(caso.segundo_nombre.downcase.strip))
          puntaje += 1 if segundo_nombre_corresponde
        end
        if !primer_apellido_corresponde && caso.primer_apellido
          primer_apellido_corresponde = text.include?(I18n.transliterate(caso.primer_apellido.downcase.strip))
          puntaje += 1 if primer_apellido_corresponde
        end
        if !segundo_apellido_corresponde && caso.segundo_apellido
          segundo_apellido_corresponde = text.include?(I18n.transliterate(caso.segundo_apellido.downcase.strip))
          puntaje += 1 if segundo_apellido_corresponde
        end
        if muestra.resultado == 2 && cantidad_positivos > cantidad_negativos
          puntaje += 1
        elsif muestra.resultado == 3 && cantidad_positivos < cantidad_negativos
          puntaje += 1
        end
      end
      muestra.pdf_match_numero_documento = numero_documento_corresponde
      muestra.pdf_match_primer_nombre    = primer_nombre_corresponde
      muestra.pdf_match_segundo_nombre   = segundo_nombre_corresponde
      muestra.pdf_match_primer_apellido  = primer_apellido_corresponde
      muestra.pdf_match_segundo_apellido = segundo_apellido_corresponde
      muestra.pdf_cantidad_positivos     = cantidad_positivos
      muestra.pdf_cantidad_negativos     = cantidad_negativos
      muestra.pdf_puntaje = puntaje
      muestra.save!
    end
  end

  def self.es_positivo?(archivo) 
    cantidad_positivos = 0
    cantidad_negativos = 0
    PDF::Reader.open(archivo.path) do |reader|
      reader.pages.each do |page|
        text = I18n.transliterate(page.text.downcase)
        cantidad_positivos += text.scan(/positivo/).length
        cantidad_negativos += text.scan(/negativo/).length
      end
    end
    cantidad_positivos > cantidad_negativos
  end

end
