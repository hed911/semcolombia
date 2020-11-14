class CreateCasoSaludPublicas < ActiveRecord::Migration[5.0]
  def change
    create_table :caso_salud_publicas do |t|
      t.date                     :fecha
      t.string                   :primer_nombre
      t.string                   :primer_apellido
      t.string                   :segundo_nombre
      t.string                   :segundo_apellido
      t.date                     :fecha_nacimiento
      t.string                   :tipo_documento
      t.string                   :numero_documento
      t.integer                  :sexo
      t.string                   :tipo_sanguineo
      t.integer                  :entidad_prestadora_id
      t.integer                  :aseguradora_id
      t.integer                  :country_id
      t.string                   :direccion_domicilio
      t.integer                  :departamento_id
      t.integer                  :municipio_id
      t.string                   :direccion
      t.string                   :telefono
      t.integer                  :country_uno_id
      t.integer                  :country_dos_id
      t.string                   :primer_nombre_contacto_uno
      t.string                   :primer_apellido_contacto_uno
      t.string                   :segundo_nombre_contacto_uno
      t.string                   :segundo_apellido_contacto_uno
      t.integer                  :country_id_contacto_uno
      t.integer                  :departamento_id_contacto_uno
      t.integer                  :municipio_id_contacto_uno
      t.string                   :direccion_contacto_uno
      t.string                   :telefono_contacto_uno
      t.integer                  :diagnostico_principal_id

      t.boolean                  :sintoma_covid_fiebre
      t.boolean                  :sintoma_covid_tos
      t.boolean                  :sintoma_covid_dificultad_respiratoria
      t.boolean                  :sintoma_covid_secrecion_nasal
      t.boolean                  :sintoma_covid_malestar_general
      t.boolean                  :sintoma_covid_dolor_muscular
      t.boolean                  :sintoma_covid_diarrea
      t.boolean                  :sintoma_covid_dolor_abdominal
      t.boolean                  :sintoma_covid_dolor_toraxico
      t.boolean                  :sintoma_covid_vomito
      t.boolean                  :relacionamiento_con_infectados
      t.boolean                  :ha_estado_fuera_del_pais

      t.boolean                  :lesion_mayor_fractura
      t.boolean                  :lesion_mayor_dislocacion
      t.boolean                  :lesion_mayor_lesion_por_aplastamiento
      t.boolean                  :lesion_mayor_amputacion
      t.boolean                  :lesion_mayor_lesion_intracraneana
      t.boolean                  :lesion_mayor_lesion_interna_de_un_organo
      t.boolean                  :lesion_ahogamiento_por_inmersion
      t.boolean                  :lesion_mayor_asfixia
      t.boolean                  :lesion_mayor_quemadura_por_corrosivos
      t.boolean                  :lesion_mayor_por_electricidad

      t.boolean                  :tejidos_blandos_esguince
      t.boolean                  :tejidos_blandos_hematoma

      t.boolean                  :herida_ampolla
      t.boolean                  :herida_abrasion
      t.boolean                  :herida_laceracion_superficial
      t.boolean                  :herida_herida_abierta
      t.boolean                  :herida_otra_herida_mayor

      t.boolean                  :cuerpo_extrano_en_el_exterior_del_ojo
      t.boolean                  :cuerpo_extrano_en_el_canal_auditivo
      t.boolean                  :cuerpo_extrano_en_nariz
      t.boolean                  :cuerpo_extrano_en_las_vias_respiratorias
      t.boolean                  :cuerpo_extrano_en_el_tracto_digestivo
      t.boolean                  :cuerpo_extrano_en_las_vias_genitourinarias
      t.boolean                  :cuerpo_extrano_en_tejido_blando
      t.boolean                  :cuerpo_extrano_en_sitios_o_lugar_no_especificado

      t.boolean                  :cara_especificamente_lesion_en_ojo
      t.boolean                  :cara_especificamente_lesiones_dentales
      t.boolean                  :cara_especificamente_lesion_en_nariz

      t.boolean                  :revision_revision_de_la_lesion
      t.boolean                  :revision_de_mas_de_una_naturaleza

      t.boolean                  :cabeza_y_cuello_cabeza
      t.boolean                  :cabeza_y_cuello_cara
      t.boolean                  :cabeza_y_cuello_cuello

      t.boolean                  :torax_espina
      t.boolean                  :torax_espalda
      t.boolean                  :torax_torax

      t.boolean                  :abdomen_abdomen
      t.boolean                  :abdomen_pelvis

      t.boolean                  :extremidades_hombro
      t.boolean                  :extremidades_brazo
      t.boolean                  :extremidades_codo
      t.boolean                  :extremidades_antebrazo
      t.boolean                  :extremidades_muneca
      t.boolean                  :extremidades_mano
      t.boolean                  :extremidades_muslo
      t.boolean                  :extremidades_rodilla
      t.boolean                  :extremidades_pierna
      t.boolean                  :extremidades_tobillo
      t.boolean                  :extremidades_pie
      t.boolean                  :extremidades_multiple_localizaciones

      t.boolean                  :cardiacos_paro_cardiaco
      t.boolean                  :cardiacos_dolor_de_pecho
      t.string                   :cardiacos_otro

      t.boolean                  :respiratorios_paro_respiratorio
      t.boolean                  :respiratorios_asma
      t.string                   :respiratorios_otro

      t.boolean                  :neurologicos_convulsion
      t.boolean                  :neurologicos_colapso_no_especificado

      t.boolean                  :gastrointestinales_nauseas_vomitos
      t.boolean                  :gastrointestinales_diarrea
      t.boolean                  :gastrointestinales_relacionadas_con_diabetes

      t.boolean                  :menor_dolor_de_cabeza
      t.boolean                  :menor_piel_rash
      t.boolean                  :menor_fiebre
      t.boolean                  :menor_dolor_ocular
      t.boolean                  :menor_dolor_de_oido
      t.boolean                  :menor_colico
      t.boolean                  :menor_debilidad
      t.boolean                  :menor_mareos
      t.boolean                  :menor_otro

      t.boolean                  :salud_mental_ansiedad
      t.boolean                  :salud_mental_trastornos_psiquiatricos

      t.boolean                  :relacionadas_con_el_calor_quemaduras_por_el_sol
      t.boolean                  :relacionadas_con_el_calor_agotamiento
      t.boolean                  :relacionadas_con_el_calor_sofocacion

      t.boolean                  :relacionadas_con_drogas_de_abuso_alcohol
      t.boolean                  :relacionadas_con_drogas_de_abuso_marihuana
      t.boolean                  :relacionadas_con_drogas_de_abuso_cocaina
      t.boolean                  :relacionadas_con_drogas_de_abuso_alucinogenos
      t.boolean                  :relacionadas_con_drogas_de_abuso_extasis
      t.boolean                  :relacionadas_con_drogas_de_abuso_solventes
      t.boolean                  :relacionadas_con_drogas_de_abuso_otro

      t.boolean                  :quimico_espuma_piel
      t.boolean                  :quimico_espuma_vias_respiratorias
      t.boolean                  :quimico_espuma_ojos
      t.boolean                  :quimico_espuma_otro

      t.integer                  :triage
      t.integer                  :estado
      t.integer                  :crue_user_id
      t.timestamps
    end
  end
end
