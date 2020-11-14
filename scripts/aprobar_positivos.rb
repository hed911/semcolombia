query = <<-FOO
  DO $$
  DECLARE

  BEGIN
    UPDATE caso_salud_publicas
    SET publico = TRUE
    WHERE estado_enfermedad = 2 AND (publico = FALSE OR publico = NULL);
    UPDATE muestras
    SET publico = TRUE
    WHERE resultado = 2 AND (publico = FALSE OR publico = NULL);
  END; $$
FOO
ActiveRecord::Base.connection.execute(query)
