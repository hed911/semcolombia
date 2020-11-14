QUERY_TESTS = <<-FOO
  to_char(muestras.fecha - INTERVAL '5 HOURS', 'yyyy-MM-dd') as fecha,
  municipios.nombre as municipio,
  caso_salud_publicas.tipo_documento,
  caso_salud_publicas.numero_documento,
  caso_salud_publicas.codigo_evento as evento,
  institucions.codigo as codigo_ips_que_envia,
  institucions.numero_sede as subcodigo_ips_que_envia,
  caso_salud_publicas.primer_nombre,
  caso_salud_publicas.segundo_nombre,
  caso_salud_publicas.primer_apellido,
  caso_salud_publicas.segundo_apellido,
  caso_salud_publicas.fecha_nacimiento,
  caso_salud_publicas.edad,
  CASE
    WHEN caso_salud_publicas.sexo = 1 THEN 'MASCULINO'
    WHEN caso_salud_publicas.sexo = 2 THEN 'FEMENINO'
    ELSE ''
  END AS sexo,
  CASE
    WHEN caso_salud_publicas.fallecido = TRUE THEN 'MUERTO'
    WHEN caso_salud_publicas.fallecido = FALSE THEN 'VIVO'
    ELSE 'VIVO'
  END AS condicion_final,
  entidad_prestadoras.nombre as eps,
  CASE
    WHEN caso_salud_publicas.regimen = 1 THEN 'SUBSIDIADO'
    WHEN caso_salud_publicas.regimen = 2 THEN 'CONTRIBUTIVO'
    WHEN caso_salud_publicas.regimen = 3 THEN 'ESPECIAL'
    WHEN caso_salud_publicas.regimen = 4 THEN 'P. EXCEPCION'
    WHEN caso_salud_publicas.regimen = 5 THEN 'NO ASEGURADO'
    ELSE ''
  END AS regimen,
  'COLOMBIA' as pais_de_nacimiento,
  countries.nombre as pais_de_nacimiento,
  departamento_residencia.nombre as departamento_residencia,
  municipio_residencia.nombre as municipio_residencia,
  barrios.nombre as barrio,
  caso_salud_publicas.direccion,
  caso_salud_publicas.telefono,
  laboratorios.nombre as laboratorio,
  CASE
    WHEN caso_salud_publicas.es_trabajador_de_salud = TRUE THEN 'SI'
    WHEN caso_salud_publicas.es_trabajador_de_salud = FALSE THEN 'NO'
    ELSE 'NO'
  END AS trabajador_de_la_salud,
  CASE
    WHEN caso_salud_publicas.relacionamiento_con_infectados = TRUE THEN 'SI'
    WHEN caso_salud_publicas.relacionamiento_con_infectados = FALSE THEN 'NO'
    ELSE 'NO'
  END AS contacto_con_caso_confirmado,
  CASE
    WHEN muestras.tipo = 1 THEN 'ASPIRADO TRAQUEAL'
    WHEN muestras.tipo = 2 THEN 'LAVADO BRONCOALVEOLAR'
    WHEN muestras.tipo = 3 THEN 'HISOPADO NASOFARINGEO'
    WHEN muestras.tipo = 4 THEN 'ASPIRADO NASOFARINGEO'
    ELSE muestras.otro_tipo
  END AS tipo_de_prueba,
  CASE
    WHEN muestras.resultado = 1 THEN 'POR DEFINIR'
    WHEN muestras.resultado = 2 AND muestras.publico = TRUE THEN 'POSITIVO'
    WHEN muestras.resultado = 2 AND muestras.publico = FALSE THEN 'POR DEFINIR'
    WHEN muestras.resultado = 3 THEN 'NEGATIVO'
    WHEN muestras.resultado = 4 THEN 'SE SOLICITA NUEVA MUESTRA'
    ELSE ''
  END AS resultado,
  muestras.observaciones,
  CASE
    WHEN muestras.estado = 1 THEN 'Muestra tomada'
    WHEN muestras.estado = 2 THEN 'Muestra recibida por coordinador'
    WHEN muestras.estado = 3 THEN 'Muestra asignada a laboratorio'
    WHEN muestras.estado = 4 THEN 'Muestra rechazada'
    WHEN muestras.estado = 5 THEN 'Muestra procesada'
    ELSE ''
  END AS extra_estado,
  to_char(muestras.fecha - INTERVAL '5 HOURS', 'yyyy-MM-dd') as extra_fecha_toma_muestra,
  to_char(muestras.fecha_recepcion_interna - INTERVAL '5 HOURS', 'yyyy-MM-dd') as extra_fecha_recibido,
  to_char(muestras.fecha_despacho_interna - INTERVAL '5 HOURS', 'yyyy-MM-dd') as extra_fecha_envio,
  institucions.nombre as extra_nombre_ips,
  CASE
    WHEN caso_salud_publicas.servicio = 1 THEN 'Hospitalizacion'
    WHEN caso_salud_publicas.servicio = 2 THEN 'Urgencia'
    WHEN caso_salud_publicas.servicio = 3 THEN 'UCI plena'
    WHEN caso_salud_publicas.servicio = 4 THEN 'UCI intermedia'
    WHEN caso_salud_publicas.servicio = 0 THEN 'No tiene'
    WHEN caso_salud_publicas.servicio = 5 THEN 'Ambulatorio'
    ELSE ''
  END AS extra_servicio_inicial,
  CASE
    WHEN caso_salud_publicas.servicio_crue = 1 THEN 'GENERAL PEDÍATRICA'
    WHEN caso_salud_publicas.servicio_crue = 2 THEN 'GENERAR ADULTOS'
    WHEN caso_salud_publicas.servicio_crue = 3 THEN 'UCI 1/2 ADULTOS'
    WHEN caso_salud_publicas.servicio_crue = 4 THEN 'UCI 1/2 NEONATAL'
    WHEN caso_salud_publicas.servicio_crue = 5 THEN 'UCI 1/2 PEDIÁTRICO'
    WHEN caso_salud_publicas.servicio_crue = 6 THEN 'UCI ADULTOS'
    WHEN caso_salud_publicas.servicio_crue = 7 THEN 'UCI NEONATAL'
    WHEN caso_salud_publicas.servicio_crue = 8 THEN 'UCI PEDIÁTRICO'
    WHEN caso_salud_publicas.servicio_crue = 9 THEN 'EN CASA'
    WHEN caso_salud_publicas.servicio_crue = 10 THEN 'FALLECIDO'
    ELSE ''
  END AS extra_servicio_actual,
  muestras.nivel as extra_contador,
  concat(quien_recibe.primer_nombre, ' ', quien_recibe.primer_apellido, ' ', quien_recibe.segundo_nombre, ' ', quien_recibe.segundo_apellido) as quien_recibe,
  concat(quien_despacha.primer_nombre, ' ', quien_despacha.primer_apellido, ' ', quien_despacha.segundo_nombre, ' ', quien_despacha.segundo_apellido) as quien_despacha,
  to_char(muestras.fecha_realizacion - INTERVAL '5 HOURS', 'yyyy-MM-dd') as extra_fecha_procesado,
  caso_salud_publicas.numero_oficial,
  caso_salud_publicas.fecha_actualizacion_iec,
  CASE
    WHEN caso_salud_publicas.cargue_masivo_id IS NOT NULL THEN 'SISMUESTRA'
    WHEN caso_salud_publicas.especial = TRUE THEN 'CARGADO MASIVAMENTE'
    ELSE 'SEMCOVID'
  END AS fuente,
  caso_salud_publicas.conglomerado,
  CASE 
    WHEN caso_salud_publicas.clasificacion = 1 THEN 'Contacto de positivo'
    WHEN caso_salud_publicas.clasificacion = 2 THEN 'Contacto de fallecido'
    WHEN caso_salud_publicas.clasificacion = 3 THEN 'Rumores'
    WHEN caso_salud_publicas.clasificacion = 4 THEN 'Búsqueda activa comunitaria'
    WHEN caso_salud_publicas.clasificacion = 5 THEN 'Búsqueda activa institucional'
    WHEN caso_salud_publicas.clasificacion = 5 THEN 'Caso Sintomático'
    ELSE ''
  END AS extra_clasificacion
FOO

QUERY_IEC = <<-FOO
  caso_salud_publicas.primer_nombre,
  caso_salud_publicas.segundo_nombre,
  caso_salud_publicas.primer_apellido,
  caso_salud_publicas.segundo_apellido,
  caso_salud_publicas.edad,
  CASE
    WHEN caso_salud_publicas.unidad_medida = 1 THEN 'AÑOS'
    WHEN caso_salud_publicas.unidad_medida = 2 THEN 'MESES'
    WHEN caso_salud_publicas.unidad_medida = 2 THEN 'DIAS'
    ELSE ''
  END AS unidad_medida,
  caso_salud_publicas.email,
  CASE
    WHEN caso_salud_publicas.regimen = 1 THEN 'SUBSIDIADO'
    WHEN caso_salud_publicas.regimen = 2 THEN 'CONTRIBUTIVO'
    WHEN caso_salud_publicas.regimen = 3 THEN 'ESPECIAL'
    WHEN caso_salud_publicas.regimen = 4 THEN 'P. EXCEPCION'
    WHEN caso_salud_publicas.regimen = 5 THEN 'NO ASEGURADO'
    ELSE ''
  END AS regimen,
  caso_salud_publicas.tipo_documento,
  caso_salud_publicas.numero_documento,
  CASE
    WHEN caso_salud_publicas.sexo = 1 THEN 'MASCULINO'
    WHEN caso_salud_publicas.sexo = 2 THEN 'FEMENINO'
    ELSE ''
  END AS sexo,
  caso_salud_publicas.tipo_sanguineo,
  entidad_prestadoras.nombre as nombre_eapb,
  institucions.nombre as nombre_institucion,
  countries.nombre as nombre_pais,
  departamento_origen.nombre as nombre_departamento,
  municipio_origen.nombre as nombre_municipio,

  barrios.nombre as nombre_barrio,
  caso_salud_publicas.direccion,
  caso_salud_publicas.telefono,
  caso_salud_publicas.observacion,
  country_uno.nombre as nombre_pais_uno,
  country_dos.nombre as nombre_pais_dos,
  caso_salud_publicas.primer_nombre_contacto_uno,
  caso_salud_publicas.primer_apellido_contacto_uno,
  caso_salud_publicas.segundo_nombre_contacto_uno,
  caso_salud_publicas.segundo_apellido_contacto_uno,
  country_contacto_uno.nombre as nombre_pais_contacto_uno,
  departamento_contacto_uno.nombre as nombre_departamento_contacto_uno,
  municipio_contacto_uno.nombre as nombre_municipio_contacto_uno,
  caso_salud_publicas.direccion_contacto_uno,
  caso_salud_publicas.telefono_contacto_uno,
  caso_salud_publicas.codigo_evento,
  caso_salud_publicas.conglomerado,
  CASE
    WHEN caso_salud_publicas.servicio = 1 THEN 'Hospitalizacion'
    WHEN caso_salud_publicas.servicio = 2 THEN 'Urgencia'
    WHEN caso_salud_publicas.servicio = 3 THEN 'UCI plena'
    WHEN caso_salud_publicas.servicio = 4 THEN 'UCI intermedia'
    WHEN caso_salud_publicas.servicio = 0 THEN 'No tiene'
    WHEN caso_salud_publicas.servicio = 5 THEN 'Ambulatorio'
    ELSE ''
  END AS extra_servicio_inicial,
  CASE
    WHEN caso_salud_publicas.tipo_contagio = 1 THEN 'IMPORTADO'
    WHEN caso_salud_publicas.tipo_contagio = 2 THEN 'RELACIONADO'
    WHEN caso_salud_publicas.tipo_contagio = 3 THEN 'EN ESTUDIO'
    ELSE ''
  END AS tipo_contagio,

  (case when caso_salud_publicas.sintoma_covid_fiebre = TRUE then 'SI' else 'NO' end) as fiebre,
  (case when caso_salud_publicas.sintoma_covid_tos = TRUE then 'SI' else 'NO' end) as tos,
  (case when caso_salud_publicas.sintoma_covid_dificultad_respiratoria = TRUE then 'SI' else 'NO' end) as dificultad_respiratoria,
  (case when caso_salud_publicas.sintoma_covid_secrecion_nasal = TRUE then 'SI' else 'NO' end) as secrecion_nasal,
  (case when caso_salud_publicas.sintoma_covid_malestar_general = TRUE then 'SI' else 'NO' end) as malestar_general,
  (case when caso_salud_publicas.sintoma_covid_dolor_muscular = TRUE then 'SI' else 'NO' end) as dolor_muscular,
  (case when caso_salud_publicas.sintoma_covid_diarrea = TRUE then 'SI' else 'NO' end) as diarrea,
  (case when caso_salud_publicas.sintoma_covid_dolor_abdominal = TRUE then 'SI' else 'NO' end) as dolor_abdominal,
  (case when caso_salud_publicas.sintoma_covid_dolor_toraxico = TRUE then 'SI' else 'NO' end) as dolor_toraxico,
  (case when caso_salud_publicas.sintoma_covid_vomito = TRUE then 'SI' else 'NO' end) as vomito,
  (case when caso_salud_publicas.relacionamiento_con_infectados = TRUE then 'SI' else 'NO' end) as relacionamiento_con_infectados,
  (case when caso_salud_publicas.ha_estado_fuera_del_pais = TRUE then 'SI' else 'NO' end) as ha_estado_fuera_del_pais,
  (case when caso_salud_publicas.es_trabajador_de_salud = TRUE then 'SI' else 'NO' end) as es_trabajador_de_salud,
  (case when caso_salud_publicas.fallecido = TRUE then 'SI' else 'NO' end) as fallecido,
  caso_salud_publicas.ciudad_uno,
  caso_salud_publicas.ciudad_dos,
  to_char(caso_salud_publicas.fecha_ingreso_uno - INTERVAL '5 HOURS', 'yyyy-MM-dd') as fecha_ingreso_uno,
  to_char(caso_salud_publicas.fecha_ingreso_dos - INTERVAL '5 HOURS', 'yyyy-MM-dd') as fecha_ingreso_dos,
  to_char(caso_salud_publicas.fecha_salida_uno - INTERVAL '5 HOURS', 'yyyy-MM-dd') as fecha_salida_uno,
  to_char(caso_salud_publicas.fecha_salida_dos - INTERVAL '5 HOURS', 'yyyy-MM-dd') as fecha_salida_dos,

  to_char(caso_salud_publicas.fecha_investigacion - INTERVAL '5 HOURS', 'yyyy-MM-dd') as fecha_investigacion,
  caso_salud_publicas.zona_residencia,
  caso_salud_publicas.ocupacion,
  to_char(caso_salud_publicas.fecha_inicio_sintomas - INTERVAL '5 HOURS', 'yyyy-MM-dd') as fecha_inicio_sintomas,
  caso_salud_publicas.lugar_contacto,
  (case when caso_salud_publicas.sintoma_covid_taquipnea = TRUE then 'SI' else 'NO' end) as taquipnea,
  (case when caso_salud_publicas.sintoma_covid_dolor_garganta = TRUE then 'SI' else 'NO' end) as dolor_garganta,
  (case when caso_salud_publicas.sintoma_escalofrios = TRUE then 'SI' else 'NO' end) as escalofrios,
  (case when caso_salud_publicas.sintoma_nauseas = TRUE then 'SI' else 'NO' end) as nauseas,
  (case when caso_salud_publicas.sintoma_mialgia = TRUE then 'SI' else 'NO' end) as mialgia,
  (case when caso_salud_publicas.sintoma_dolor_cabeza = TRUE then 'SI' else 'NO' end) as dolor_cabeza,
  (case when caso_salud_publicas.sintoma_asma = TRUE then 'SI' else 'NO' end) as asma,
  (case when caso_salud_publicas.sintoma_enfermedad_pulmonar_cronica = TRUE then 'SI' else 'NO' end) as enfermedad_pulmonar_cronica,
  (case when caso_salud_publicas.sintoma_trastorno_neurologico_cronico = TRUE then 'SI' else 'NO' end) as trastorno_neurologico_cronico,
  (case when caso_salud_publicas.sintoma_inmunosupresion = TRUE then 'SI' else 'NO' end) as inmunosupresion,
  (case when caso_salud_publicas.sintoma_enfermedad_renal_cronica = TRUE then 'SI' else 'NO' end) as enfermedad_renal_cronica,
  (case when caso_salud_publicas.sintoma_enfermedad_cardiaca = TRUE then 'SI' else 'NO' end) as enfermedad_cardiaca,
  (case when caso_salud_publicas.sintoma_enfermedad_hematologica_cronica = TRUE then 'SI' else 'NO' end) as enfermedad_hematologica,
  (case when caso_salud_publicas.sintoma_diabetes = TRUE then 'SI' else 'NO' end) as diabetes,
  (case when caso_salud_publicas.sintoma_obesidad = TRUE then 'SI' else 'NO' end) as obesidad,
  (case when caso_salud_publicas.sintoma_enfermedad_hepatica_cronica = TRUE then 'SI' else 'NO' end) as enfermedad_hepatica_cronica,
  (case when caso_salud_publicas.sintoma_embarazo = TRUE then 'SI' else 'NO' end) as embarazo,
  caso_salud_publicas.semanas_gestacion,
  (case when caso_salud_publicas.sintoma_tabaquismo = TRUE then 'SI' else 'NO' end) as tabaquismo,
  (case when caso_salud_publicas.sintoma_alcoholismo = TRUE then 'SI' else 'NO' end) as alcoholismo,
  (case when caso_salud_publicas.sintoma_transtorno_reumatologico = TRUE then 'SI' else 'NO' end) as trastorno_reumatologico,
  responsable_investigacion.primer_nombre as responsable_investigacion,
  (case when responsable_investigacion.id IS NOT NULL then 'Realizado' else 'Pendiente' end) as estado_iec,
  to_char(caso_salud_publicas.fecha_actualizacion_iec - INTERVAL '5 HOURS', 'yyyy-MM-dd') as fecha_actualizacion_iec,
  CASE
    WHEN caso_salud_publicas.cargue_masivo_id IS NOT NULL THEN 'SISMUESTRA'
    WHEN caso_salud_publicas.especial = TRUE THEN 'CARGADO MASIVAMENTE'
    ELSE 'SEMCOVID'
  END AS fuente,
  caso_salud_publicas.conglomerado,
  CASE 
    WHEN caso_salud_publicas.clasificacion = 1 THEN 'Contacto de positivo'
    WHEN caso_salud_publicas.clasificacion = 2 THEN 'Contacto de fallecido'
    WHEN caso_salud_publicas.clasificacion = 3 THEN 'Rumores'
    WHEN caso_salud_publicas.clasificacion = 4 THEN 'Búsqueda activa comunitaria'
    WHEN caso_salud_publicas.clasificacion = 5 THEN 'Búsqueda activa institucional'
    WHEN caso_salud_publicas.clasificacion = 5 THEN 'Caso Sintomático'
    ELSE ''
  END AS clasificacion
FOO

QUERY_CONTACTOS = <<-FOO
  parent.primer_nombre AS principal_primer_nombre,
  parent.segundo_nombre AS principal_segundo_nombre,
  parent.primer_apellido AS principal_primer_apellido,
  parent.segundo_apellido AS principal_segundo_apellido,
  parent.tipo_documento AS principal_tipo_documento,
  parent.numero_documento AS principal_numero_documento,
  parent.direccion AS principal_direccion,
  parent.telefono AS principal_telefono,

  caso_salud_publicas.primer_nombre AS relacionado_primer_nombre,
  caso_salud_publicas.segundo_nombre AS relacionado_segundo_nombre,
  caso_salud_publicas.primer_apellido AS relacionado_primer_apellido,
  caso_salud_publicas.segundo_apellido AS relacionado_segundo_apellido,
  caso_salud_publicas.tipo_documento AS relacionado_tipo_documento,
  caso_salud_publicas.numero_documento AS relacionado_numero_documento
FOO

=begin
(SELECT COUNT(*) FROM contactos as x WHERE x.parent_id = caso_salud_publicas.id) as cantidad_contactos,
(SELECT COUNT(*) FROM muestras as x WHERE x.caso_salud_publica_id = caso_salud_publicas.id) as cantidad_muestras,
(SELECT COUNT(*) FROM desplazamientos as x WHERE x.caso_salud_publica_id = caso_salud_publicas.id) as cantidad_desplazamientos,
(SELECT COUNT(*) FROM consultas as x WHERE x.caso_salud_publica_id = caso_salud_publicas.id) as cantidad_consultas,
=end

QUERY_SEGUIMIENTOS = <<-FOO
  (case when s.asintomatico = TRUE then 'SI' else 'NO' end) as asintomatico,
  (case when s.temperatura = TRUE then 'SI' else 'NO' end) as temperatura_mayor_38_grados,
  (case when s.tos = TRUE then 'SI' else 'NO' end) as tos,
  (case when s.dificultad_respiratoria = TRUE then 'SI' else 'NO' end) as dificultad_respiratoria,
  (case when s.odinofagia = TRUE then 'SI' else 'NO' end) as odinofagia,
  (case when s.fatiga = TRUE then 'SI' else 'NO' end) as fatiga_adinamia,
  regexp_replace(s.contenido, '[^-0-9A-Za-z ]', '', 'g') as observacion,
  (case when s.llamada_fallida = TRUE then 'SI' else 'NO' end) as llamada_fallida,
  s.created_at as fecha,
  c.primer_nombre,
  c.segundo_nombre,
  c.primer_apellido,
  c.segundo_apellido,
  c.edad,
  CASE
    WHEN c.unidad_medida = 1 THEN 'AÑOS'
    WHEN c.unidad_medida = 2 THEN 'MESES'
    WHEN c.unidad_medida = 2 THEN 'DIAS'
    ELSE ''
  END AS unidad_medida,
  c.email,
  CASE
    WHEN c.regimen = 1 THEN 'SUBSIDIADO'
    WHEN c.regimen = 2 THEN 'CONTRIBUTIVO'
    WHEN c.regimen = 3 THEN 'ESPECIAL'
    WHEN c.regimen = 4 THEN 'P. EXCEPCION'
    WHEN c.regimen = 5 THEN 'NO ASEGURADO'
    ELSE ''
  END AS regimen,
  c.tipo_documento,
  c.numero_documento
FOO