DROP FUNCTION remisiones_vencidas(municipio_id_ int);
/* FALTA HACER QUE RECIBA EL PARAMETRO DE MUNICIPIO_ID */
/* Y QUE SEA OPCIONAL ... */
CREATE OR REPLACE FUNCTION remisiones_vencidas(municipio_id_ int)
  RETURNS TABLE (
    id int,
    descripcion text,
    estado int,
    hospital_user_id int,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    institucion_emisor_id int,
    institucion_receptor_id int,
    respuesta text,
    categoria_referencia_id int,
    crue_user_id int,
    nivel int,
    numero_identificacion character varying,
    edad int,
    nombre_completo character varying,
    diagnostico text,
    tipo_documento int,
    contrareferencia text,
    municipio_id int,
    diagnostico_id int,
    entidad_prestadora_id int,
    ingreso_id int,
    fecha_auditoria_eps timestamp without time zone,
    fecha_auditoria_crue timestamp without time zone,
    fecha_aprobacion_institucion timestamp without time zone,
    fecha_cierre timestamp without time zone,
    auditor_eps_id int,
    auditor_crue_id int,
    auditor_asignacion_institucion_id int,
    auditor_cierre_id int,
    municipio_pagador_id int,
    aprobado_at timestamp without time zone,
    motivo_rechazo character varying,
    rechazado_at timestamp without time zone,
    departamento_id int,
    municipio_crack_eps_id int,
    departamento_crack_eps_id int,
    departamento_pagador_id int
  ) AS
$func$
BEGIN
    IF municipio_id_ IS NULL THEN
      RETURN QUERY
      SELECT s.* from super_remisions as s
      WHERE s.estado IN (1, 2, 4) AND LOCALTIMESTAMP > s.created_at + (6 || ' hours')::INTERVAL;
    ELSE
      RETURN QUERY
      SELECT s.* from super_remisions as s
      WHERE s.municipio_crack_eps_id = municipio_id_ AND s.entidad_prestadora_id IS NOT NULL AND s.estado IN (1, 2, 4) AND LOCALTIMESTAMP > s.created_at + (6 || ' hours')::INTERVAL;
    END IF;
END
$func$ LANGUAGE plpgsql;

# ESTA CONSULTA OBTIENE TODAS LAS REMISIONES QUE HAYAN SIDO ASIGNADAS A UNA EAPB
# PERO EL TIEMPO LIMITE PARA CONTESTAR YA SE SOBREPASO
# SE FILTRA EL MUNICIPIO HACIA EL CUAL SE DESTINÓ LA REMISION
# POR EL HECHO DE QUE ESTA PUEDE SER EXTERNA OSEA DE OTRO MUNICIPIO
