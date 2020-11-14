CREATE OR REPLACE FUNCTION municipios_contenidos(latitude_ float, longitude_ float)
  RETURNS TABLE (
     id int,
     nombre character varying,
     departamento_id int,
     created_at timestamp without time zone,
     updated_at timestamp without time zone,
     zonas_geo geometry
  ) AS
$func$
BEGIN
    RETURN QUERY
    SELECT m.id, m.nombre, m.departamento_id, m.created_at, m.updated_at, m.zonas_geo
    FROM municipios m
    WHERE st_contains(m.zonas_geo, ST_Point(longitude_, latitude_));
END
$func$ LANGUAGE plpgsql;


/*DROP FUNCTION municipios_contenidos(latitude_ float, longitude_ float)
SELECT * FROM municipios_contenidos(1.922, 1.29292)*/
