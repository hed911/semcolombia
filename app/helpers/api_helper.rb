
module ApiHelper

  def self.fetch_casos_barranquilla(params)
    hash = {}
    hash[:municipio] = Municipio.find(4)
    hash[:municipio_origen] = Municipio.find(4)
    errors = []
    if !params.has_key?(:pagina)
      errors << "Parametro (pagina) es obligatorio"
    else
      if !params[:pagina].numeric?
        errors << "Parametro (pagina) debe ser numerico"
      end
    end
    if !params.has_key?(:cantidad_registros)
      errors << "Parametro (cantidad_registros) es obligatorio"
    else
      if !params[:cantidad_registros].numeric?
        errors << "Parametro (cantidad_registros) debe ser numerico"
      end
    end
    if errors.any?
      return {errors:errors, data:nil}
    end
    casos = CasoSaludPublica.where(hash).order('created_at ASC').paginate(page: params[:pagina], per_page: params[:cantidad_registros])
    result = Jbuilder.encode do |json|
      json.set! "total", casos.count
      json.set! "cantidadPaginas", casos.total_pages
      json.items do |json|
        json.array! casos.each do |caso|
          json.set! "numeroDoc", caso.numero_documento
          json.set! "latitud", caso.latitude
          json.set! "longitud", caso.longitude
          json.set! "direccion", caso.direccion
          json.set! "numeroOficial", caso.numero_oficial
          json.set! "caso", caso.id
          json.set! "ciudad", caso.municipio_origen && caso.municipio_origen.nombre ? caso.municipio_origen.nombre.capitalize : nil
          json.set! "edad", caso.edad_value
          json.set! "sexo", caso.sexo == 1 ? "M" : "F"
          json.set! "tipo", caso.tipo_contagio_value.capitalize
          json.set! "paisProcedencia", caso.country && caso.country.nombre ? caso.country.nombre.capitalize : nil
          json.set! "fecDiag", caso.fecha_inicio_sintomas ? caso.fecha_inicio_sintomas.strftime('%d/%m/%Y%l:%M %p') : nil
          json.set! "fecRecuperacion", caso.fecha_recuperacion ? caso.fecha_recuperacion.strftime('%d/%m/%Y%l:%M %p') : nil
          json.set! "fecFallecimiento", caso.fecha_fallecimiento ? caso.fecha_fallecimiento.strftime('%d/%m/%Y%l:%M %p') : nil
          json.set! "localidad", caso.barrio && caso.barrio.localidad ? caso.barrio.localidad.nombre.upcase : nil
          json.set! "barrio", caso.barrio ? caso.barrio.nombre.upcase : nil
          json.set! "atencion", caso.estado_enfermedad_value
          json.set! "dia", nil
        	json.set! "semana": nil
        	json.set! "estrato": nil
        	json.set! "diaMes": nil
        	json.set! "mes": nil
        	json.set! "tasaContagio": nil
        end
      end
    end
    return {errors:errors, data:JSON.parse(result)}
  end

  def self.fetch_casos_cartagena(params)
    hash = {}
    hash[:municipio] = Municipio.find(27)
    errors = []
    if !params.has_key?(:pagina)
      errors << "Parametro (pagina) es obligatorio"
    else
      if !params[:pagina].numeric?
        errors << "Parametro (pagina) debe ser numerico"
      end
    end
    if !params.has_key?(:cantidad_registros)
      errors << "Parametro (cantidad_registros) es obligatorio"
    else
      if !params[:cantidad_registros].numeric?
        errors << "Parametro (cantidad_registros) debe ser numerico"
      end
    end
    if errors.any?
      return {errors:errors, data:nil}
    end
    casos = CasoSaludPublica.where(hash).order('created_at ASC').paginate(page: params[:pagina], per_page: params[:cantidad_registros])
    result = Jbuilder.encode do |json|
      json.set! "total", casos.count
      json.set! "cantidadPaginas", casos.total_pages
      json.items do |json|
        json.array! casos.each do |caso|
          json.set! "numeroDoc", caso.numero_documento
          json.set! "latitud", caso.latitude
          json.set! "longitud", caso.longitude
          json.set! "direccion", caso.direccion
          json.set! "caso", caso.id
          json.set! "fecDiag", caso.fecha_inicio_sintomas ? caso.fecha_inicio_sintomas.strftime('%d/%m/%Y%l:%M %p') : nil
          json.set! "estado", caso.estado_enfermedad_value
        end
      end
    end
    return {errors:errors, data:JSON.parse(result)}
  end

  def self.fetch_casos(municipio, params)
    hash = {}
    hash[:municipio] = municipio
    errors = []
    if !params.has_key?(:pagina)
      errors << "Parametro (pagina) es obligatorio"
    else
      if !params[:pagina].numeric?
        errors << "Parametro (pagina) debe ser numerico"
      end
    end
    if !params.has_key?(:cantidad_registros)
      errors << "Parametro (cantidad_registros) es obligatorio"
    else
      if !params[:cantidad_registros].numeric?
        errors << "Parametro (cantidad_registros) debe ser numerico"
      end
    end
    if errors.any?
      return {errors:errors, data:nil}
    end
    casos = CasoSaludPublica.where(hash).order('created_at ASC').paginate(page: params[:pagina], per_page: params[:cantidad_registros])
    result = Jbuilder.encode do |json|
      json.set! "total", casos.count
      json.set! "cantidadPaginas", casos.total_pages
      json.items do |json|
        json.array! casos.each do |caso|
          json.set! "numeroDoc", caso.numero_documento
          json.set! "latitud", caso.latitude
          json.set! "longitud", caso.longitude
          json.set! "direccion", caso.direccion
          json.set! "caso", caso.id
          json.set! "fecDiag", caso.fecha_inicio_sintomas ? caso.fecha_inicio_sintomas.strftime('%d/%m/%Y%l:%M %p') : nil
          json.set! "estado", caso.estado_enfermedad_value
        end
      end
    end
    return {errors:errors, data:JSON.parse(result)}
  end

end
