DROP FUNCTION remisiones_pendientes(entidad_prestadora_id_ int, departamento_id_ int, municipio_id_ int);
CREATE OR REPLACE FUNCTION remisiones_pendientes(entidad_prestadora_id_ int, departamento_id_ int, municipio_id_ int)
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
    IF departamento_id_ IS NOT NULL THEN
      RETURN QUERY
      SELECT s.* from super_remisions as s, municipios as m
      WHERE s.estado NOT IN (5, 6, 7 ,8) AND m.departamento_crack_eps_id = departamento_id_ AND s.municipio_crack_eps_id = m.id AND s.entidad_prestadora_id = entidad_prestadora_id_ AND LOCALTIMESTAMP < s.created_at + (6 || ' hours')::INTERVAL
      ORDER BY s.created_at ASC;
    ELSE
      IF municipio_id_ IS NOT NULL THEN
        RETURN QUERY
        SELECT s.* from super_remisions as s
        WHERE s.estado NOT IN (5, 6, 7 ,8) AND s.municipio_crack_eps_id = municipio_id_ AND s.entidad_prestadora_id = entidad_prestadora_id_ AND LOCALTIMESTAMP < s.created_at + (6 || ' hours')::INTERVAL
        ORDER BY s.created_at ASC;
      ELSE
        RETURN QUERY
        SELECT s.* from super_remisions as s
        WHERE s.estado NOT IN (5, 6, 7 ,8) AND s.entidad_prestadora_id = entidad_prestadora_id_ AND LOCALTIMESTAMP < s.created_at + (6 || ' hours')::INTERVAL
        ORDER BY s.created_at ASC;
      END IF;
    END IF;
END
$func$ LANGUAGE plpgsql;

# ESTA CONSULTA DEVUELVE AQUELLOS REGISTROS LOS CUALES NO HAN SIDO FINALIZADOS, OSEA LOS QUE NO ESTEN EN ESTADO (5)
# ES DECIR TODOS LOS REGISTROS APARECERAN EN LA CONSULTA DE PENDIENTES A NO SER QUE SE FINALICE EL PROCESO POR LA IPS COMO TAL
# TENIENDO EN CUENTA EL CAMPO municipio_crack_eps_id PORQUE ESTE ES EL CAMPO QUE SE ACTIVA CUANDO UNA SOLICITUD
# TIENE UNA EAPB ASIGNADA, EN ESTE CAMPO SE GUARDA EL ID DEL MUNICIPIO HACIA DONDE VA DICHA REMISION


# OJO, PARA QUE FUNCIONE BIEN EL ASUNTO DE LA RESTA DE HORAS EN UNA CONSULTA plpgsql
# HAY QUE TENER EN CUENTA 3 COSAS:
# 1-) COLOCAR EL TIMEZONE DE HEROKU EN UTC CON EL COMANDO heroku config:add TZ="Etc/GMT"
# 2-) COLOCAR EN EL ARCHIVO config/application.rb LAS SIGUIENTES DOS LINEAS
# config.time_zone = 'America/Bogota'
# config.active_record.default_timezone = :utc
# 3-) COLOCAR LAS SIGUIENTES DOS LINEAS EN EL ARCHIVO app.rb de SINATRA
# Time.zone = 'America/Bogota'
# ActiveRecord::Base.default_timezone = :utc
