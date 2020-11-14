DROP FUNCTION autorizaciones_vencidas(municipio_id_ int);
/* FALTA HACER QUE RECIBA EL PARAMETRO DE MUNICIPIO_ID */
/* Y QUE SEA OPCIONAL ... */
CREATE OR REPLACE FUNCTION autorizaciones_vencidas(municipio_id_ int)
  RETURNS TABLE (
    id int,
    estado int,
    respondido_at timestamp without time zone,
    respondido_eps_at timestamp without time zone,
    ingreso_id int,
    municipio_pagador_id int,
    hospital_user_id int,
    crue_user_id int,
    institucion_id int,
    entidad_prestadora_id int,
    auditor_eps_id int,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    anulado_at timestamp without time zone,
    rechazado_at timestamp without time zone,
    aprobado_at timestamp without time zone,
    porcentaje_cuota_moderadora int,
    porcentaje_copago int,
    porcentaje_cuota_recuperacion int,
    porcentaje_otro int,
    valor_cuota_moderadora int,
    valor_copago int,
    valor_cuota_recuperacion int,
    valor_otro int,
    valor_max_porcentaje_cuota_moderadora int,
    valor_max_porcentaje_valor_copago int,
    valor_max_porcentaje_valor_cuota_recuperacion int,
    valor_max_porcentaje_valor_otro int,
    porcentaje_pago int,
    reclamo_tiquete boolean,
    departamento_pagador_id int,
    municipio_crack_eps_id int,
    departamento_crack_eps_id int,
    motivo_rechazo text,
    municipio_id int,
    departamento_id int
  ) AS
$func$
BEGIN
    IF municipio_id_ IS NULL THEN
      RETURN QUERY
      SELECT a.* from autorizacions as a
      WHERE a.estado = 1 AND LOCALTIMESTAMP > a.created_at + (6 || ' hours')::INTERVAL;
    ELSE
      RETURN QUERY
      SELECT a.* from autorizacions as a
      WHERE a.municipio_id = municipio_id_ AND a.entidad_prestadora_id IS NOT NULL AND a.estado = 1 AND LOCALTIMESTAMP > a.created_at + (6 || ' hours')::INTERVAL;
    END IF;
END
$func$ LANGUAGE plpgsql;
