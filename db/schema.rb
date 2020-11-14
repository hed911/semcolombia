# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 44998336229940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"
  enable_extension "pg_stat_statements"
  enable_extension "postgis"

  create_table "afiliacions", id: :integer, default: -> { "nextval('autorizacions_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "estado"
    t.datetime "respondido_at"
    t.integer "crue_user_id"
    t.integer "ingreso_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "municipio_id"
    t.integer "hospital_user_id"
    t.integer "institucion_id"
    t.integer "entidad_prestadora_id"
    t.datetime "respondido_eps_at"
    t.integer "auditor_eps_id"
  end

  create_table "alertas", id: :serial, force: :cascade do |t|
    t.string "barrio"
    t.string "direccion"
    t.text "observacion"
    t.integer "crue_user_id"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ambulancias", id: :serial, force: :cascade do |t|
    t.integer "estado"
    t.string "codigo_habilitacion"
    t.string "numero_sede"
    t.integer "tipo"
    t.integer "nivel", default: 0
    t.boolean "indigena"
    t.boolean "habilitada"
    t.integer "modelo"
    t.string "numero_tarjeta"
    t.integer "empresa_ambulancia_id"
    t.float "latitude"
    t.float "longitude"
    t.boolean "disponible", default: false
    t.float "distancia"
    t.datetime "updated_position_at"
    t.string "placa", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "municipio_id"
    t.integer "radiooperador_id"
    t.integer "paramedico_id"
    t.integer "medico_id"
    t.boolean "atiende_hogar"
    t.boolean "atiende_soat"
    t.boolean "atiende_traslado"
    t.date "fecha_habilitacion"
    t.date "fecha_vencimiento"
    t.string "serie", limit: 255
    t.string "marca", limit: 255
    t.string "linea", limit: 255
    t.string "cilindraje", limit: 255
    t.string "combustible", limit: 255
    t.string "motor", limit: 255
    t.string "nombre_propietario", limit: 255
    t.string "cedula_propietario", limit: 255
    t.string "telefono_propietario", limit: 255
    t.string "direccion_propietario", limit: 255
    t.string "tarjeta_operacion", limit: 255
    t.date "expedicion_tarjeta_operacion"
    t.string "serial_tarjeta_operacion", limit: 255
    t.date "vencimiento_tarjeta_operacion"
    t.string "soat", limit: 255
    t.date "expedicion_soat"
    t.string "serial_soat", limit: 255
    t.date "vencimiento_soat"
    t.string "tecnicomecanica", limit: 255
    t.date "expedicion_tecnicomecanica"
    t.string "serial_tecnicomecanica", limit: 255
    t.date "vencimiento_tecnicomecanica"
    t.string "uuid", limit: 255
    t.string "url", limit: 255
    t.datetime "last_ping_time"
    t.float "latitude_parqueo"
    t.float "longitude_parqueo"
    t.string "xmpp_id", limit: 255
    t.index ["placa"], name: "index_ambulancias_on_placa", unique: true
    t.index ["reset_password_token"], name: "index_ambulancias_on_reset_password_token", unique: true
  end

  create_table "archivos", id: :serial, force: :cascade do |t|
    t.string "full_name"
    t.integer "super_remision_id"
    t.integer "afiliacion_id"
    t.integer "ingreso_id"
    t.text "real_name"
    t.integer "muestra_id"
    t.text "uuid"
    t.integer "cargue_masivo_pdf_id"
  end

  create_table "arls", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "codigo", limit: 255
  end

  create_table "aseguradoras", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "codigo", limit: 255
  end

  create_table "asset_categoria_primer_respondientes", id: :serial, force: :cascade do |t|
    t.string "url_imagen"
    t.string "url_video"
    t.string "public_id"
    t.integer "categoria_interna_glosario_primer_respondiente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "asset_categorias", id: :serial, force: :cascade do |t|
    t.integer "categoria_interna_glosario_id"
    t.string "url_imagen"
    t.string "url_video"
    t.string "public_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "autorizacion_procedimientos", id: false, force: :cascade do |t|
    t.integer "autorizacion_id"
    t.integer "procedimiento_id"
    t.integer "cantidad"
  end

  create_table "autorizacions", id: :serial, force: :cascade do |t|
    t.integer "estado"
    t.datetime "respondido_at"
    t.datetime "respondido_eps_at"
    t.integer "ingreso_id"
    t.integer "municipio_pagador_id"
    t.integer "hospital_user_id"
    t.integer "crue_user_id"
    t.integer "institucion_id"
    t.integer "entidad_prestadora_id"
    t.integer "auditor_eps_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "anulado_at"
    t.datetime "rechazado_at"
    t.datetime "aprobado_at"
    t.integer "porcentaje_cuota_moderadora"
    t.integer "porcentaje_copago"
    t.integer "porcentaje_cuota_recuperacion"
    t.integer "porcentaje_otro"
    t.integer "valor_cuota_moderadora"
    t.integer "valor_copago"
    t.integer "valor_cuota_recuperacion"
    t.integer "valor_otro"
    t.integer "valor_max_porcentaje_cuota_moderadora"
    t.integer "valor_max_porcentaje_copago"
    t.integer "valor_max_porcentaje_cuota_recuperacion"
    t.integer "valor_max_porcentaje_otro"
    t.integer "porcentaje_pago"
    t.boolean "reclamo_tiquete"
    t.integer "departamento_pagador_id"
    t.integer "municipio_crack_eps_id"
    t.integer "departamento_crack_eps_id"
    t.text "motivo_rechazo"
    t.integer "municipio_id"
    t.integer "departamento_id"
  end

  create_table "barrios", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.integer "municipio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "localidad_id"
    t.string "internal_id"
  end

  create_table "camas", id: :serial, force: :cascade do |t|
    t.string "numero", limit: 255
    t.string "etiqueta", limit: 255
    t.integer "estado"
    t.integer "institucion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "tipo"
    t.integer "tipo_cama_id"
    t.integer "ingreso_id"
  end

  create_table "capacidads", id: :serial, force: :cascade do |t|
    t.string "grupo"
    t.string "coca"
    t.integer "cantidad"
    t.string "numero_sede_principal"
    t.string "numero_placa"
    t.string "modalidad"
    t.string "modelo"
    t.string "numero_tarjeta"
    t.integer "institucion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "caracterizacion_nivel_fours", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.integer "caracterizacion_nivel_three_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "caracterizacion_nivel_ones", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "caracterizacion_nivel_threes", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.integer "caracterizacion_nivel_two_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "caracterizacion_nivel_twos", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.integer "caracterizacion_nivel_one_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cargue_masivo_pdfs", id: :serial, force: :cascade do |t|
    t.text "errores"
    t.string "archivo_file_name"
    t.string "archivo_content_type"
    t.integer "archivo_file_size"
    t.datetime "archivo_updated_at"
    t.integer "cantidad_registros"
    t.integer "creadas"
    t.integer "estado"
    t.integer "oid"
    t.string "archivo"
    t.integer "municipio_id"
    t.integer "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cargue_masivos", id: :serial, force: :cascade do |t|
    t.text "errores"
    t.string "archivo_file_name"
    t.string "archivo_content_type"
    t.integer "archivo_file_size"
    t.datetime "archivo_updated_at"
    t.integer "cantidad_registros"
    t.text "Ya_creadas_anteriormente"
    t.text "creadas"
    t.integer "estado"
    t.datetime "fecha_finalizacion"
    t.integer "oid"
    t.string "archivo"
    t.integer "municipio_id"
    t.integer "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "file_contents"
  end

  create_table "caso_deportivos", id: :serial, force: :cascade do |t|
    t.string "puesto_atencion"
    t.date "fecha_atencion"
    t.integer "tipo_asistente"
    t.string "tipo_documento"
    t.string "numero_documento"
    t.string "nombre_paciente"
    t.string "edad"
    t.string "nacionalidad"
    t.string "sexo"
    t.string "direccion_residencia"
    t.string "barrio"
    t.string "telefono"
    t.string "email"
    t.boolean "lesion_mayor_fractura"
    t.boolean "lesion_mayor_dislocacion"
    t.boolean "lesion_mayor_lesion_por_aplastamiento"
    t.boolean "lesion_mayor_traumatismo"
    t.boolean "lesion_mayor_amputacion"
    t.boolean "lesion_mayor_lesion_intracraneana"
    t.boolean "lesion_mayor_lesion_interna_de_un_organo"
    t.boolean "lesion_ahogamiento_por_inmersion"
    t.boolean "lesion_mayor_asfixia"
    t.boolean "lesion_mayor_quemadura_por_corrosivos"
    t.boolean "lesion_mayor_por_electricidad"
    t.boolean "tejidos_blandos_esguince"
    t.boolean "tejidos_blandos_hematoma"
    t.boolean "herida_ampolla"
    t.boolean "herida_abrasion"
    t.boolean "herida_laceracion_superficial"
    t.boolean "herida_herida_abierta"
    t.boolean "herida_otra_herida_mayor"
    t.boolean "cuerpo_extrano_en_el_exterior_del_ojo"
    t.boolean "cuerpo_extrano_en_el_canal_auditivo"
    t.boolean "cuerpo_extrano_en_nariz"
    t.boolean "cuerpo_extrano_en_las_vias_respiratorias"
    t.boolean "cuerpo_extrano_en_el_tracto_digestivo"
    t.boolean "cuerpo_extrano_en_las_vias_genitourinarias"
    t.boolean "cuerpo_extrano_en_tejido_blando"
    t.boolean "cuerpo_extrano_en_sitios_o_lugar_no_especificado"
    t.boolean "cara_especificamente_lesion_en_ojo"
    t.boolean "cara_especificamente_lesiones_dentales"
    t.boolean "cara_especificamente_lesion_en_nariz"
    t.boolean "revision_revision_de_la_lesion"
    t.boolean "revision_de_mas_de_una_naturaleza"
    t.boolean "cabeza_y_cuello_cabeza"
    t.boolean "cabeza_y_cuello_cara"
    t.boolean "cabeza_y_cuello_cuello"
    t.boolean "torax_espina"
    t.boolean "torax_espalda"
    t.boolean "torax_torax"
    t.boolean "abdomen_abdomen"
    t.boolean "abdomen_pelvis"
    t.boolean "extremidades_hombro"
    t.boolean "extremidades_brazo"
    t.boolean "extremidades_codo"
    t.boolean "extremidades_antebrazo"
    t.boolean "extremidades_muneca"
    t.boolean "extremidades_mano"
    t.boolean "extremidades_muslo"
    t.boolean "extremidades_rodilla"
    t.boolean "extremidades_pierna"
    t.boolean "extremidades_tobillo"
    t.boolean "extremidades_pie"
    t.boolean "extremidades_multiple_localizaciones"
    t.boolean "cardiacos_paro_cardiaco"
    t.boolean "cardiacos_dolor_de_pecho"
    t.string "cardiacos_otro"
    t.boolean "respiratorios_paro_respiratorio"
    t.boolean "respiratorios_asma"
    t.string "respiratorios_otro"
    t.boolean "neurologicos_convulsion"
    t.boolean "neurologicos_colapso_no_especificado"
    t.boolean "gastrointestinales_nauseas_vomitos"
    t.boolean "gastrointestinales_diarrea"
    t.boolean "gastrointestinales_relacionadas_con_diabetes"
    t.boolean "menor_dolor_de_cabeza"
    t.boolean "menor_piel_rash"
    t.boolean "menor_fiebre"
    t.boolean "menor_dolor_ocular"
    t.boolean "menor_dolor_de_oido"
    t.boolean "menor_colico"
    t.string "menor_debilidad"
    t.boolean "menor_mareos"
    t.string "menor_otro"
    t.boolean "relacionadas_con_el_calor_quemaduras_por_el_sol"
    t.boolean "relacionadas_con_el_calor_agotamiento"
    t.boolean "relacionadas_con_el_calor_sofocacion"
    t.boolean "relacionadas_con_el_frio_hipotermia"
    t.boolean "relacionadas_con_el_frio_congelacion"
    t.boolean "relacionadas_con_drogas_de_abuso_alcohol"
    t.boolean "relacionadas_con_drogas_de_abuso_marihuana"
    t.boolean "relacionadas_con_drogas_de_abuso_cocaina"
    t.boolean "relacionadas_con_drogas_de_abuso_alucinogenos"
    t.boolean "relacionadas_con_drogas_de_abuso_extasis"
    t.boolean "relacionadas_con_drogas_de_abuso_solventes"
    t.string "relacionadas_con_drogas_de_abuso_otro"
    t.integer "relacionadas_con_picadura"
    t.string "agente_causante"
    t.integer "relacionadas_con_alimentos"
    t.string "agente_causante_de_la_eta"
    t.boolean "salud_mental_ansiedad"
    t.boolean "salud_mental_trastornos_psiquiatricos"
    t.boolean "quimico_espuma_piel"
    t.boolean "quimico_espuma_vias_respiratorias"
    t.boolean "quimico_espuma_ojos"
    t.string "quimico_espuma_otro"
    t.integer "lugar_de_la_atencion"
    t.string "lugar_de_la_atencion_otro"
    t.boolean "referido_a_ips_urgencia"
    t.integer "referido_a"
    t.string "nombre_ips_receptora"
    t.string "traslado_ips_fue_en_otro"
    t.string "nombre_empresa_ambulancia"
    t.text "nota"
    t.integer "entidad_prestadora_id"
    t.integer "evento_deportivo_id"
    t.integer "operario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "traslado_ips_fue_en"
    t.string "referido_a_otro", limit: 255
    t.integer "codigo_id"
    t.string "tipo_evento", limit: 255
    t.integer "diagnostico_id"
    t.integer "estado_seguimiento"
    t.text "json_paso_uno"
    t.text "json_paso_dos"
    t.text "json_paso_tres"
    t.string "departamento", limit: 255
    t.string "distrito_especial", limit: 255
    t.boolean "covid"
  end

  create_table "caso_policias", id: :serial, force: :cascade do |t|
    t.integer "estado"
    t.datetime "fecha_llamada"
    t.string "codigo_llamada"
    t.string "numero_telefonico"
    t.string "medio_notificacion"
    t.string "codigo_1"
    t.string "descripcion_codigo_1"
    t.string "codigo_2"
    t.string "descripcion_codigo_2"
    t.string "direccion"
    t.integer "codigo_barrio"
    t.float "latitude"
    t.float "longitude"
    t.string "nombre_reportante"
    t.string "nombre_propietario"
    t.string "direccion_propietario"
    t.string "barrio_propietario"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nombre_barrio", limit: 255
    t.float "latitude_propietario"
    t.float "longitude_propietario"
    t.text "observacion"
    t.integer "caso_repetido_id"
    t.string "codigo_llamada_repetido", limit: 255
    t.boolean "ha_estado_infectado"
    t.boolean "reinfeccion"
  end

  create_table "caso_salud_publicas", id: :serial, force: :cascade do |t|
    t.date "fecha"
    t.string "primer_nombre"
    t.string "primer_apellido"
    t.string "segundo_nombre"
    t.string "segundo_apellido"
    t.date "fecha_nacimiento"
    t.string "tipo_documento"
    t.string "numero_documento"
    t.integer "sexo"
    t.string "tipo_sanguineo"
    t.integer "entidad_prestadora_id"
    t.integer "aseguradora_id"
    t.integer "country_id"
    t.string "direccion_domicilio"
    t.integer "departamento_id"
    t.integer "municipio_id"
    t.string "direccion"
    t.string "telefono"
    t.integer "country_uno_id"
    t.integer "country_dos_id"
    t.string "primer_nombre_contacto_uno"
    t.string "primer_apellido_contacto_uno"
    t.string "segundo_nombre_contacto_uno"
    t.string "segundo_apellido_contacto_uno"
    t.integer "country_id_contacto_uno"
    t.integer "departamento_id_contacto_uno"
    t.integer "municipio_id_contacto_uno"
    t.string "direccion_contacto_uno"
    t.string "telefono_contacto_uno"
    t.integer "diagnostico_principal_id"
    t.boolean "sintoma_covid_fiebre"
    t.boolean "sintoma_covid_tos"
    t.boolean "sintoma_covid_dificultad_respiratoria"
    t.boolean "sintoma_covid_secrecion_nasal"
    t.boolean "sintoma_covid_malestar_general"
    t.boolean "sintoma_covid_dolor_muscular"
    t.boolean "sintoma_covid_diarrea"
    t.boolean "sintoma_covid_dolor_abdominal"
    t.boolean "sintoma_covid_dolor_toraxico"
    t.boolean "sintoma_covid_vomito"
    t.boolean "relacionamiento_con_infectados"
    t.boolean "ha_estado_fuera_del_pais"
    t.boolean "lesion_mayor_fractura"
    t.boolean "lesion_mayor_dislocacion"
    t.boolean "lesion_mayor_lesion_por_aplastamiento"
    t.boolean "lesion_mayor_amputacion"
    t.boolean "lesion_mayor_lesion_intracraneana"
    t.boolean "lesion_mayor_lesion_interna_de_un_organo"
    t.boolean "lesion_ahogamiento_por_inmersion"
    t.boolean "lesion_mayor_asfixia"
    t.boolean "lesion_mayor_quemadura_por_corrosivos"
    t.boolean "lesion_mayor_por_electricidad"
    t.boolean "tejidos_blandos_esguince"
    t.boolean "tejidos_blandos_hematoma"
    t.boolean "herida_ampolla"
    t.boolean "herida_abrasion"
    t.boolean "herida_laceracion_superficial"
    t.boolean "herida_herida_abierta"
    t.boolean "herida_otra_herida_mayor"
    t.boolean "cuerpo_extrano_en_el_exterior_del_ojo"
    t.boolean "cuerpo_extrano_en_el_canal_auditivo"
    t.boolean "cuerpo_extrano_en_nariz"
    t.boolean "cuerpo_extrano_en_las_vias_respiratorias"
    t.boolean "cuerpo_extrano_en_el_tracto_digestivo"
    t.boolean "cuerpo_extrano_en_las_vias_genitourinarias"
    t.boolean "cuerpo_extrano_en_tejido_blando"
    t.boolean "cuerpo_extrano_en_sitios_o_lugar_no_especificado"
    t.boolean "cara_especificamente_lesion_en_ojo"
    t.boolean "cara_especificamente_lesiones_dentales"
    t.boolean "cara_especificamente_lesion_en_nariz"
    t.boolean "revision_revision_de_la_lesion"
    t.boolean "revision_de_mas_de_una_naturaleza"
    t.boolean "cabeza_y_cuello_cabeza"
    t.boolean "cabeza_y_cuello_cara"
    t.boolean "cabeza_y_cuello_cuello"
    t.boolean "torax_espina"
    t.boolean "torax_espalda"
    t.boolean "torax_torax"
    t.boolean "abdomen_abdomen"
    t.boolean "abdomen_pelvis"
    t.boolean "extremidades_hombro"
    t.boolean "extremidades_brazo"
    t.boolean "extremidades_codo"
    t.boolean "extremidades_antebrazo"
    t.boolean "extremidades_muneca"
    t.boolean "extremidades_mano"
    t.boolean "extremidades_muslo"
    t.boolean "extremidades_rodilla"
    t.boolean "extremidades_pierna"
    t.boolean "extremidades_tobillo"
    t.boolean "extremidades_pie"
    t.boolean "extremidades_multiple_localizaciones"
    t.boolean "cardiacos_paro_cardiaco"
    t.boolean "cardiacos_dolor_de_pecho"
    t.string "cardiacos_otro"
    t.boolean "respiratorios_paro_respiratorio"
    t.boolean "respiratorios_asma"
    t.string "respiratorios_otro"
    t.boolean "neurologicos_convulsion"
    t.boolean "neurologicos_colapso_no_especificado"
    t.boolean "gastrointestinales_nauseas_vomitos"
    t.boolean "gastrointestinales_diarrea"
    t.boolean "gastrointestinales_relacionadas_con_diabetes"
    t.boolean "menor_dolor_de_cabeza"
    t.boolean "menor_piel_rash"
    t.boolean "menor_fiebre"
    t.boolean "menor_dolor_ocular"
    t.boolean "menor_dolor_de_oido"
    t.boolean "menor_colico"
    t.boolean "menor_debilidad"
    t.boolean "menor_mareos"
    t.boolean "menor_otro"
    t.boolean "salud_mental_ansiedad"
    t.boolean "salud_mental_trastornos_psiquiatricos"
    t.boolean "relacionadas_con_el_calor_quemaduras_por_el_sol"
    t.boolean "relacionadas_con_el_calor_agotamiento"
    t.boolean "relacionadas_con_el_calor_sofocacion"
    t.boolean "relacionadas_con_drogas_de_abuso_alcohol"
    t.boolean "relacionadas_con_drogas_de_abuso_marihuana"
    t.boolean "relacionadas_con_drogas_de_abuso_cocaina"
    t.boolean "relacionadas_con_drogas_de_abuso_alucinogenos"
    t.boolean "relacionadas_con_drogas_de_abuso_extasis"
    t.boolean "relacionadas_con_drogas_de_abuso_solventes"
    t.boolean "relacionadas_con_drogas_de_abuso_otro"
    t.boolean "quimico_espuma_piel"
    t.boolean "quimico_espuma_vias_respiratorias"
    t.boolean "quimico_espuma_ojos"
    t.boolean "quimico_espuma_otro"
    t.integer "triage"
    t.integer "estado"
    t.integer "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "estado_seguimiento"
    t.string "referencia"
    t.string "otro_barrio"
    t.float "latitude"
    t.float "longitude"
    t.boolean "relacionado"
    t.integer "regimen"
    t.integer "edad"
    t.integer "unidad_medida"
    t.string "email"
    t.string "ciudad_uno"
    t.string "ciudad_dos"
    t.date "fecha_ingreso_uno"
    t.date "fecha_ingreso_dos"
    t.date "fecha_salida_uno"
    t.date "fecha_salida_dos"
    t.integer "barrio_id"
    t.integer "nivel"
    t.integer "usuario_seguimiento_id"
    t.integer "origen"
    t.integer "estado_enfermedad"
    t.integer "usuario_cierre_id"
    t.integer "institucion_id"
    t.text "observacion"
    t.datetime "touched_at"
    t.integer "touched_by_id"
    t.integer "laboratorio_id"
    t.integer "servicio"
    t.integer "municipio_origen_id"
    t.integer "departamento_origen_id"
    t.integer "codigo_evento"
    t.boolean "es_trabajador_de_salud"
    t.boolean "fallecido"
    t.integer "tipo_contagio"
    t.boolean "publico", default: false
    t.boolean "especial", default: false
    t.integer "numero_oficial"
    t.datetime "fecha_actualizacion_estado_enfermedad"
    t.datetime "fecha_actualizacion_servicio"
    t.boolean "ha_estado_infectado", default: false
    t.boolean "reinfeccion", default: false
    t.integer "estado_seguimiento_crue"
    t.date "fecha_defuncion"
    t.boolean "tiene_ventilador", default: false
    t.integer "servicio_crue"
    t.date "fecha_investigacion"
    t.integer "zona_residencia"
    t.text "ocupacion"
    t.date "fecha_inicio_sintomas"
    t.text "lugar_contacto"
    t.boolean "sintoma_covid_taquipnea"
    t.boolean "sintoma_covid_dolor_garganta"
    t.boolean "sintoma_escalofrios"
    t.boolean "sintoma_nauseas"
    t.boolean "sintoma_mialgia"
    t.boolean "sintoma_dolor_cabeza"
    t.boolean "sintoma_asma"
    t.boolean "sintoma_enfermedad_pulmonar_cronica"
    t.boolean "sintoma_trastorno_neurologico_cronico"
    t.boolean "sintoma_inmunosupresion"
    t.boolean "sintoma_enfermedad_renal_cronica"
    t.boolean "sintoma_enfermedad_cardiaca"
    t.boolean "sintoma_enfermedad_hematologica_cronica"
    t.boolean "sintoma_diabetes"
    t.boolean "sintoma_obesidad"
    t.boolean "sintoma_enfermedad_hepatica_cronica"
    t.boolean "sintoma_embarazo"
    t.integer "semanas_gestacion"
    t.boolean "sintoma_tabaquismo"
    t.boolean "sintoma_alcoholismo"
    t.integer "responsable_investigacion_id"
    t.boolean "sintoma_transtorno_reumatologico"
    t.text "otra_patologia"
    t.boolean "asintomatico"
    t.datetime "fecha_fallecimiento"
    t.datetime "fecha_recuperacion"
    t.datetime "fecha_actualizacion_iec"
    t.integer "cargue_masivo_id"
    t.string "conglomerado"
  end

  create_table "categoria_eventos", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "municipio_id"
  end

  create_table "categoria_glosario_primer_respondientes", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categoria_glosarios", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categoria_interna_glosario_primer_respondientes", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.integer "categoria_glosario_primer_respondiente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categoria_interna_glosarios", id: :serial, force: :cascade do |t|
    t.integer "categoria_glosario_id"
    t.string "nombre"
    t.text "descripcion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categoria_referencias", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categoria_referencias_institucions", id: false, force: :cascade do |t|
    t.integer "categoria_referencia_id"
    t.integer "institucion_id"
  end

  create_table "categoria_referencias_super_remisions", id: false, force: :cascade do |t|
    t.integer "super_remision_id"
    t.integer "categoria_referencia_id"
  end

  create_table "coberturas", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "constancias", id: :serial, force: :cascade do |t|
    t.string "institucion", limit: 255
    t.string "solicitado_por", limit: 255
    t.string "radicado_interno", limit: 255
    t.string "radicado_externo", limit: 255
    t.string "radicado_oficio_ogc", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consultas", id: :serial, force: :cascade do |t|
    t.string "institucion"
    t.date "fecha"
    t.integer "caso_salud_publica_id"
    t.integer "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contactos", id: :serial, force: :cascade do |t|
    t.string "parentezco"
    t.integer "parent_id"
    t.integer "son_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tipo_contacto"
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.string "codigo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "custom_tables", id: :serial, force: :cascade do |t|
    t.text "observacion"
    t.integer "estado"
    t.boolean "notificacion_de_apoyo"
    t.integer "primer_respondiente_id"
    t.integer "evento_primer_respondiente_id"
    t.text "causa"
    t.datetime "fecha_apoyo"
    t.datetime "fecha_cierre"
    t.datetime "fecha_ocultacion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "defuncions", id: :serial, force: :cascade do |t|
    t.string "primer_nombre"
    t.string "primer_apellido"
    t.string "segundo_nombre"
    t.string "segundo_apellido"
    t.string "tipo_identificacion"
    t.string "numero_documento"
    t.integer "sexo"
    t.date "fecha_nacimiento"
    t.string "barrio"
    t.string "diagnostico"
    t.string "medico"
    t.string "aph"
    t.text "observacion"
    t.integer "estado"
    t.integer "crue_user_id"
    t.integer "municipio_id"
    t.integer "entidad_prestadora_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by", limit: 255
    t.string "queue", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "departamentos", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "codigo_dane"
    t.string "codigo"
  end

  create_table "desastre_casos", id: :serial, force: :cascade do |t|
    t.string "causa"
    t.string "barrio"
    t.boolean "esta_en_embarazo"
    t.boolean "esta_discapacitado"
    t.text "observacion"
    t.string "primer_nombre"
    t.string "primer_apellido"
    t.string "segundo_nombre"
    t.string "segundo_apellido"
    t.string "tipo_identificacion"
    t.string "numero_documento"
    t.integer "sexo"
    t.date "fecha_nacimiento"
    t.integer "estado"
    t.integer "desastre_id"
    t.integer "crue_user_id"
    t.integer "hospital_user_id"
    t.integer "institucion_id"
    t.integer "municipio_id"
    t.integer "departamento_caso_id"
    t.integer "municipio_caso_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "desastres", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.string "observacion"
    t.integer "municipio_id"
    t.integer "crue_user_id"
    t.integer "hospital_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "desplazamientos", id: :serial, force: :cascade do |t|
    t.text "contenido"
    t.integer "caso_salud_publica_id"
    t.integer "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "fecha"
  end

  create_table "devices", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.string "token"
    t.string "refresh_token"
    t.string "provider"
    t.boolean "renovado"
    t.string "apid"
    t.boolean "invalidado"
    t.string "ambulancia_id"
    t.datetime "expiration_date"
    t.integer "operario_id"
    t.integer "tripulante_id"
    t.integer "primer_respondiente_id"
    t.string "os"
  end

  create_table "diagnosticos", id: :serial, force: :cascade do |t|
    t.integer "super_remision_id"
    t.float "cantidad_horas_limite"
    t.string "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "codigo", limit: 255
  end

  create_table "dispositivos", id: :serial, force: :cascade do |t|
    t.string "token"
    t.string "serial"
    t.integer "ambulancia_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "empresa_ambulancias", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "municipio_id"
    t.string "codigo_habilitacion", limit: 255
    t.string "nit", limit: 255
    t.string "direccion", limit: 255
    t.string "telefono", limit: 255
    t.string "email_gerente", limit: 255
    t.datetime "fecha_radicacion"
    t.string "nombre_gerente", limit: 255
    t.string "email_notificacion_uno", limit: 255
    t.string "email_notificacion_dos", limit: 255
    t.string "telefono_notificacion_uno", limit: 255
    t.string "telefono_notificacion_dos", limit: 255
    t.string "secad_id", limit: 255
  end

  create_table "empresa_ambulancias_entidad_prestadoras", id: false, force: :cascade do |t|
    t.integer "entidad_prestadora_id"
    t.integer "empresa_ambulancia_id"
  end

  create_table "entidad_prestadora_institucions", id: false, force: :cascade do |t|
    t.integer "municipio_id"
    t.integer "entidad_prestadora_id"
    t.integer "institucion_id"
  end

  create_table "entidad_prestadoras", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "codigo", limit: 255
    t.boolean "especial", default: false
    t.string "roles", limit: 255
  end

  create_table "entidad_prestadoras_institucions", id: false, force: :cascade do |t|
    t.integer "institucion_id"
    t.integer "entidad_prestadora_id"
  end

  create_table "entidad_prestadoras_municipios", id: false, force: :cascade do |t|
    t.integer "entidad_prestadora_id"
    t.integer "municipio_id"
  end

  create_table "entidadsaluds", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entregas", id: :serial, force: :cascade do |t|
    t.string "primer_nombre_paciente"
    t.string "segundo_nombre_paciente"
    t.string "primer_apellido_paciente"
    t.string "segundo_apellido_paciente"
    t.integer "tipo_documento_paciente"
    t.string "numero_documento_paciente"
    t.date "fecha_nacimiento_paciente"
    t.integer "tipo_ingreso"
    t.datetime "fecha_ingreso"
    t.boolean "remitido"
    t.string "codigo_habilitacion_ingreso"
    t.string "departamento_ingreso"
    t.string "municipio_ingreso"
    t.boolean "trasladada_transporte_especial"
    t.string "codigo_prestador_transporte_especial"
    t.string "placa_transporte_especial"
    t.datetime "fecha_accidente"
    t.string "departamento_accidente"
    t.string "municipio_accidente"
    t.string "direccion_accidente"
    t.string "placa"
    t.boolean "vehiculo_no_identificado"
    t.string "primer_nombre_vehiculo_involucrado"
    t.string "segundo_nombre_vehiculo_involucrado"
    t.string "primer_apellido_vehiculo_involucrado"
    t.string "segundo_apellido_vehiculo_involucrado"
    t.string "tipo_documento_vehiculo_involucrado"
    t.string "numero_documento_vehiculo_involucrado"
    t.string "direccion_vehiculo_involucrado"
    t.string "telefono_vehiculo_involucrado"
    t.string "departamento_vehiculo_involucrado"
    t.string "municipio_vehiculo_involucrado"
    t.integer "evento_ambulatorio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "escenarios", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.string "direccion"
    t.text "descripcion"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "municipio_id"
    t.string "categoria", limit: 255
  end

  create_table "escenarios_institucions", id: false, force: :cascade do |t|
    t.integer "institucion_id"
    t.integer "escenario_id"
  end

  create_table "evento_deportivos", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.datetime "fecha_inicio"
    t.integer "lugar_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "escenario_id"
    t.datetime "fecha_fin"
    t.datetime "fecha"
  end

  create_table "evento_primer_respondiente_notificados_primer_respondientes", id: false, force: :cascade do |t|
    t.integer "primer_respondiente_id"
    t.integer "evento_primer_respondiente_id"
  end

  create_table "evento_primer_respondientes", force: :cascade do |t|
    t.string "nombre_paciente"
    t.string "direccion"
    t.float "latitude"
    t.float "longitude"
    t.text "descripcion"
    t.integer "evento_ambulatorio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "estado"
  end

  create_table "evento_primer_respondientes_primer_respondientes", id: false, force: :cascade do |t|
    t.integer "primer_respondiente_id"
    t.integer "evento_primer_respondiente_id"
  end

  create_table "eventos", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "eventos_ambulatorios", id: :serial, force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.string "direccion"
    t.text "observacion"
    t.string "nombre_paciente"
    t.integer "nivel"
    t.datetime "aceptado_at"
    t.datetime "paciente_recogido_at"
    t.datetime "paciente_entregado_at"
    t.integer "ambulancia_id"
    t.integer "institucion_id"
    t.integer "estado"
    t.integer "crue_user_id"
    t.string "cedula"
    t.integer "evento_relacionado_raiz_id"
    t.integer "evento_encadenado_raiz_id"
    t.float "distancia"
    t.string "uuid"
    t.boolean "incumplimiento"
    t.boolean "ingreso_datos_ambulancia"
    t.integer "soat_id"
    t.string "nombre_paciente_ambulancia"
    t.string "cedula_ambulancia"
    t.integer "tipo_documento_ambulancia"
    t.integer "nivel_ambulancia"
    t.text "observacion_ambulancia"
    t.string "cedula_url_imagen"
    t.string "soat_url_imagen"
    t.integer "categoria_evento_id"
    t.integer "hospital_user_id"
    t.integer "estado_cumplimiento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "tipo"
    t.string "telefono", limit: 255
    t.string "evento_url_imagen", limit: 255
    t.string "uuid_tu_red", limit: 255
    t.integer "proyecto_id"
    t.datetime "paciente_confirmado_at"
    t.string "nombre_quien_recibe", limit: 255
    t.string "cedula_quien_recibe", limit: 255
    t.text "observacion_final"
    t.integer "municipio_id"
    t.integer "radiooperador_id"
    t.integer "paramedico_id"
    t.integer "medico_id"
    t.integer "tipo_tu_red"
    t.boolean "hogar"
    t.boolean "transito"
    t.boolean "traslado"
    t.integer "llamada_id"
    t.boolean "ocultar", default: false
    t.boolean "ocultar_ips", default: false
    t.integer "nivel_complejidad_calculado"
    t.string "fosyga", limit: 255
    t.string "sisben", limit: 255
    t.string "dnp", limit: 255
    t.integer "archivo_fosyga_id"
    t.integer "archivo_sisben_id"
    t.integer "archivo_dnp_id"
    t.integer "motivo_cancelacion_id"
    t.boolean "hospital_no_pudo_recibir_paciente", default: false
    t.integer "caso_deportivo_id"
    t.string "placas", limit: 255
    t.boolean "cumple_rango_triage"
    t.boolean "pulso_radial"
    t.boolean "palidez_generalizada"
    t.boolean "sudoracion_profusa"
    t.boolean "sangrado_activo"
    t.boolean "respira"
    t.boolean "cianosis"
    t.boolean "aleteo_nasal"
    t.boolean "taqipnea"
    t.boolean "heridas_externas"
    t.boolean "heridas_penetrantes"
    t.boolean "heridas_abiertas"
    t.boolean "exposicion_organos"
    t.boolean "obedece_ordenes"
    t.boolean "moviliza_dos_o_mas"
    t.boolean "moviliza_una_o_dos"
    t.boolean "ausencia_movimientos"
    t.boolean "palabras_claras"
    t.boolean "palabras_confusas"
    t.boolean "palabras_incomprensibles"
    t.boolean "ausencia_lenguaje"
    t.float "latitude_triage"
    t.float "longitude_triage"
    t.integer "cancelado_por_id"
    t.text "motivo_cancelacion"
    t.integer "caso_policia_id"
    t.integer "auditado_por_id"
    t.integer "estado_seguimiento"
    t.float "latitude_confirmacion"
    t.float "longitude_confirmacion"
    t.float "latitude_llevado_hospital"
    t.float "longitude_llevado_hospital"
    t.float "latitude_cancelacion"
    t.float "longitude_cancelacion"
    t.datetime "cancelado_at"
    t.boolean "institucion_reasignada", default: false
    t.integer "reasignado_por_id"
    t.integer "institucion_original_id"
    t.boolean "proviene_caso_rechazado", default: false
    t.text "observacion_rechazo"
    t.integer "rechazado_por_id"
    t.boolean "sms_enviado"
    t.text "observacion_reasignacion"
    t.text "observacion_cumplido"
  end

  create_table "eventos_vigilancias", id: false, force: :cascade do |t|
    t.integer "id", default: -> { "nextval('eventos_id_seq'::regclass)" }, null: false
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "evolucions", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "frecuenciaeventos", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "historial_ambulancias", id: :serial, force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.integer "ambulancia_id"
    t.float "speed"
    t.float "accuracy"
    t.string "provider"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "radiooperador_id"
    t.integer "paramedico_id"
    t.integer "medico_id"
    t.integer "tipo"
    t.boolean "is_mock"
    t.string "gps_location", limit: 255
    t.string "gps_permission", limit: 255
    t.string "gps_providers", limit: 255
    t.string "gps_status", limit: 255
  end

  create_table "historial_habilitacions", id: :serial, force: :cascade do |t|
    t.text "observacion"
    t.boolean "estado"
    t.boolean "contenido"
    t.integer "ambulancia_id"
    t.integer "crue_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "historial_recurso_urgencias", id: :serial, force: :cascade do |t|
    t.integer "institucion_id"
    t.integer "usuario_id"
    t.integer "hospital_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "estado_urgencia"
  end

  create_table "historial_recursos", id: :integer, default: -> { "nextval('historialrecursos_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "sueros_antiofilicos"
    t.integer "sangres_ab_positivo"
    t.integer "sangres_ab_negativo"
    t.integer "sangres_b_positivo"
    t.integer "sangres_b_negativo"
    t.integer "sangres_o_positivo"
    t.integer "sangres_o_negativo"
    t.integer "sangres_a_positivo"
    t.integer "sangres_a_negativo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "institucion_id"
    t.integer "usuario_id"
    t.integer "hospital_user_id"
    t.integer "adultos"
    t.integer "cuidado_agudo_mental"
    t.integer "cuidado_basico_neonatal"
    t.integer "cuidado_intensivo_adulto"
    t.integer "cuidado_intensivo_neonatal"
    t.integer "cuidado_intensivo_pediatrico"
    t.integer "cuidado_intermedio_adulto"
    t.integer "cuidado_intermedio_mental"
    t.integer "cuidado_intermedio_neonatal"
    t.integer "cuidado_intermedio_pediatrico"
    t.integer "farmacodependencia"
    t.integer "institucion_paciente_cronico"
    t.integer "obstetricia"
    t.integer "pediatrica"
    t.integer "psiquiatrica"
    t.integer "salud_mental"
    t.integer "transplante_de_progenitores_hematopoyeticos"
  end

  create_table "historial_urgencias", id: :serial, force: :cascade do |t|
    t.integer "heridos_arma_fuego"
    t.integer "heridos_arma_blanca"
    t.integer "heridos_arma_contundente"
    t.integer "heridos_accidente_transito"
    t.integer "urgencias_totales_atendidas"
    t.integer "pacientes_observacion"
    t.integer "cirugias_urgencias"
    t.integer "institucion_id"
    t.integer "usuario_id"
    t.integer "hospital_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "historialincidentes", id: :serial, force: :cascade do |t|
    t.integer "hospital_id"
    t.integer "erupciones_cutaneas"
    t.integer "heridos_arma_fuego"
    t.integer "heridos_arma_blanca"
    t.integer "heridos_arma_contundente"
    t.integer "intoxicados_alcohol"
    t.integer "intoxicados_exogenas"
    t.integer "intoxicados_alimenticios"
    t.integer "personas_quemadas"
    t.integer "heridos_accidente_transito"
    t.integer "intoxicados_escopolamina"
    t.integer "urgencias_totales_atendidas"
    t.integer "pacientes_en_observacion"
    t.integer "cirugias_de_urgencia"
    t.string "responsable_informacion", limit: 255
    t.string "nombre_completo", limit: 255
    t.integer "edad"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hospital_users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "primer_nombre", limit: 255
    t.string "primer_apellido", limit: 255
    t.string "segundo_nombre", limit: 255
    t.string "segundo_apellido", limit: 255
    t.integer "institucion_id"
    t.string "identificacion", limit: 255
    t.string "cargo", limit: 255
    t.datetime "fecha_vigencia"
    t.boolean "activo"
    t.boolean "envio_correo"
    t.text "roles"
    t.string "telefono", limit: 255
    t.integer "entidad_prestadora_id"
    t.integer "municipio_id"
    t.integer "departamento_id"
    t.integer "hospital_user_id"
    t.integer "usuario_id"
    t.string "roles_admitidos", limit: 255
    t.integer "aseguradora_id"
    t.string "xmpp_id", limit: 255
    t.index ["email"], name: "index_hospital_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_hospital_users_on_reset_password_token", unique: true
  end

  create_table "hospitals", id: :serial, force: :cascade do |t|
    t.integer "municipio_id"
    t.string "nombre", limit: 255
    t.string "direccion", limit: 255
    t.string "hora_dia", limit: 255
    t.string "nombre_radio_operador", limit: 255
    t.string "lider_paso", limit: 255
    t.string "telefono_institucional", limit: 255
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ingresos", id: :integer, default: -> { "nextval('paciente_camas_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "primer_nombre"
    t.string "primer_apellido"
    t.string "segundo_nombre"
    t.string "segundo_apellido"
    t.integer "tipo_documento"
    t.string "numero_documento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "hospital_user_id"
    t.datetime "liberado_at"
    t.date "fecha_nacimiento"
    t.string "direccion_residencia_habitual", limit: 255
    t.string "telefono", limit: 255
    t.integer "cobertura_salud_id"
    t.integer "origen_atencion_id"
    t.integer "triage"
    t.datetime "fecha_ingreso"
    t.boolean "paciente_remitido"
    t.text "motivo_consulta"
    t.integer "destino_id"
    t.integer "institucion_remitente_id"
    t.integer "diagnostico_principal_id"
    t.integer "diagnostico_uno_id"
    t.integer "diagnostico_dos_id"
    t.integer "diagnostico_tres_id"
    t.string "numero_atencion", limit: 255
    t.integer "institucion_id"
    t.integer "estado"
    t.integer "entidad_prestadora_id"
    t.integer "municipio_id"
    t.boolean "virtual", default: false
    t.integer "super_remision_id"
    t.integer "municipio_origen_id"
    t.integer "departamento_origen_id"
    t.integer "departamento_id"
    t.integer "toxico_id"
    t.integer "crue_user_id"
    t.integer "evento_ambulatorio_id"
    t.integer "aseguradora_id"
    t.integer "tipo"
    t.string "placas", limit: 255
    t.integer "nacionalidad_id"
    t.string "direccion_accidente", limit: 255
    t.string "medio_llegada"
    t.integer "arl_id"
    t.datetime "fecha_accidente"
    t.integer "estado_cumplimiento"
    t.datetime "vence_at"
    t.text "observacion_cumplimiento"
    t.integer "aprobador_id "
    t.integer "municipio_accidente_id"
    t.integer "departamento_accidente_id"
    t.datetime "edicion_vence_at"
    t.integer "aprobador_id"
    t.string "nombre_concatenado", limit: 255
  end

  create_table "inscripcions", id: :serial, force: :cascade do |t|
    t.integer "servicioinscripcion_id"
    t.string "prestador", limit: 255
    t.string "consulta", limit: 255
    t.string "radicado_externo", limit: 255
    t.string "radicado_interno", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "institucions", id: :serial, force: :cascade do |t|
    t.string "codigo", limit: 255
    t.string "nombre", limit: 255
    t.boolean "activo", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "direccion", limit: 255
    t.string "telefono", limit: 255
    t.string "nit", limit: 255
    t.string "roles", limit: 255
    t.integer "nivel"
    t.float "latitude"
    t.float "longitude"
    t.integer "municipio_id"
    t.integer "numero_sede"
    t.string "email", limit: 255
    t.integer "dv"
    t.string "clase_persona", limit: 255
    t.string "naju_nombre", limit: 255
    t.boolean "ese", default: false
    t.string "caracter", limit: 255
    t.string "grse_nombre", limit: 255
    t.string "serv_nombre", limit: 255
    t.boolean "ambulatorio", default: false
    t.boolean "hospitalario", default: false
    t.boolean "unidad_movil", default: false
    t.boolean "domiciliario", default: false
    t.boolean "otras_extramural", default: false
    t.boolean "centro_referencia", default: false
    t.boolean "institucion_remisora", default: false
    t.date "fecha_apertura"
    t.date "fecha_cierre"
    t.string "numero_distintivo", limit: 255
    t.integer "numero_sede_principal"
    t.float "distancia"
    t.string "telefono_contacto_uno", limit: 255
    t.string "telefono_contacto_dos", limit: 255
    t.string "telefono_contacto_tres", limit: 255
    t.string "telefono_contacto_cuatro", limit: 255
    t.string "telefono_contacto_cinco", limit: 255
    t.string "email_contacto_uno", limit: 255
    t.string "email_contacto_dos", limit: 255
    t.string "email_contacto_tres", limit: 255
    t.string "email_contacto_cuatro", limit: 255
    t.string "email_contacto_cinco", limit: 255
    t.string "telefono_contacto_seis", limit: 255
    t.string "email_contacto_seis", limit: 255
    t.integer "nivel_complejidad"
    t.boolean "atiende_salud_mental"
    t.integer "municipio_alterno_id"
    t.integer "estado_urgencia", default: 1
    t.integer "entidad_prestadora_id"
    t.integer "parent_id"
    t.string "subcodigo", limit: 255
  end

  create_table "intensions", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "crea_casos"
    t.integer "municipio_id"
  end

  create_table "laboratorios", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.string "direccion"
    t.string "telefono"
    t.string "nit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "municipio_id"
    t.boolean "coordinacion", default: false
  end

  create_table "limite_tipo_camas", id: :serial, force: :cascade do |t|
    t.integer "institucion_id"
    t.integer "tipo_cama_id"
    t.integer "cantidad"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "llamadas", id: :serial, force: :cascade do |t|
    t.text "descripcion"
    t.integer "intension"
    t.integer "caso_salud_publica_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id"
    t.integer "intension_id"
    t.string "tipo_documento"
    t.string "numero_documento"
    t.string "primer_nombre"
    t.string "segundo_nombre"
    t.string "primer_apellido"
    t.string "segundo_apellido"
    t.string "email"
    t.string "telefono_fijo"
    t.string "celular"
    t.integer "departamento_id"
    t.integer "municipio_id"
    t.boolean "autoriza"
    t.integer "departamento_origen_id"
    t.integer "municipio_origen_id"
  end

  create_table "localidads", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "internal_id"
  end

  create_table "logs", id: :serial, force: :cascade do |t|
    t.text "descripcion"
    t.text "data"
    t.integer "evento_ambulatorio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ambulancia_id"
  end

  create_table "lugars", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.text "descripcion"
    t.string "direccion"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "metodoeventos", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "motivoanulacions", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "muestras", id: :serial, force: :cascade do |t|
    t.integer "tipo"
    t.integer "resultado"
    t.string "otro_tipo"
    t.integer "laboratorio_id"
    t.integer "institucion_id"
    t.integer "caso_salud_publica_id"
    t.integer "usuario_emisor_id"
    t.integer "usuario_finalizador_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "temperatura"
    t.text "observaciones"
    t.integer "prueba"
    t.integer "metodo_utilizado"
    t.integer "objeto_prueba"
    t.string "codigo_analista"
    t.string "codigo_responsable_tecnico"
    t.string "codigo"
    t.datetime "fecha"
    t.datetime "fecha_realizacion"
    t.integer "estado"
    t.datetime "fecha_recepcion"
    t.datetime "fecha_recepcion_interna"
    t.datetime "fecha_despacho_interna"
    t.datetime "fecha_rechazo_interna"
    t.datetime "fecha_procesado_interna"
    t.integer "laboratorio_asignado_id"
    t.datetime "fecha_recepcion_interna_laboratorio_asignado"
    t.boolean "publico", default: false
    t.integer "nivel"
    t.boolean "oculto", default: false
    t.string "codigo_archivo"
    t.integer "quien_recibe_id"
    t.integer "quien_despacha_id"
    t.boolean "especial"
    t.boolean "pdf_match_numero_documento"
    t.boolean "pdf_match_primer_nombre"
    t.boolean "pdf_match_segundo_nombre"
    t.boolean "pdf_match_primer_apellido"
    t.boolean "pdf_match_segundo_apellido"
    t.integer "pdf_cantidad_positivos"
    t.integer "pdf_cantidad_negativos"
    t.integer "pdf_puntaje"
    t.integer "cargue_masivo_id"
  end

  create_table "municipios", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "departamento_id"
    t.geometry "zonas_geo", limit: {:srid=>0, :type=>"multi_polygon"}
    t.float "default_latitude"
    t.float "default_longitude"
    t.boolean "habilitado_remisiones", default: false
    t.boolean "habilitado_autorizaciones", default: false
    t.string "codigo", limit: 255
  end

  create_table "nacionalidads", id: :serial, force: :cascade do |t|
    t.string "codigo"
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nivelinstitucions", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nivels", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notificacion_emergentes", id: :serial, force: :cascade do |t|
    t.text "titulo"
    t.integer "estado"
    t.integer "municipio_id"
    t.integer "entidad_prestadora_id"
    t.integer "institucion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "descripcion"
    t.text "url"
    t.integer "usuario_id"
  end

  create_table "notificacions", id: :serial, force: :cascade do |t|
    t.integer "ambulancia_id"
    t.integer "evento_ambulatorio_id"
    t.integer "estado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.float "distancia"
  end

  create_table "novedad_eventos", id: :serial, force: :cascade do |t|
    t.string "observacion"
    t.integer "evento_ambulatorio_id"
    t.integer "ambulancia_id"
    t.integer "crue_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "novedads", id: :serial, force: :cascade do |t|
    t.string "prestador", limit: 255
    t.string "descripcion", limit: 255
    t.string "radicado_externo", limit: 255
    t.string "radicado_interno", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operarios", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "cedula"
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.datetime "updated_position_at"
    t.index ["email"], name: "index_operarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_operarios_on_reset_password_token", unique: true
  end

  create_table "origens", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pacientes", id: :serial, force: :cascade do |t|
    t.integer "barrio_id"
    t.integer "entidadsalud_id"
    t.string "primer_nombre", limit: 255
    t.string "primer_apellido", limit: 255
    t.string "segundo_nombre", limit: 255
    t.string "segundo_apellido", limit: 255
    t.integer "sexo"
    t.integer "edad"
    t.integer "unidades_edad"
    t.integer "tipo_documento"
    t.string "numero_documento", limit: 255
    t.string "direccion", limit: 255
    t.string "telefono", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "evento_ambulatorio_id"
    t.string "nombre", limit: 255
    t.date "fecha_nacimiento"
    t.string "direccion_residencia_habitual", limit: 255
    t.integer "cobertura_salud_id"
    t.integer "origen_atencion_id"
    t.integer "triage"
    t.date "fecha_ingreso"
    t.string "motivo_consulta", limit: 255
    t.integer "diagnostico_principal_id"
    t.integer "diagnostico_uno_id"
    t.integer "diagnostico_dos_id"
    t.integer "diagnostico_tres_id"
    t.string "numero_atencion", limit: 255
    t.integer "entidad_prestadora_id"
    t.integer "municipio_id"
    t.integer "departamento_id"
    t.integer "aseguradora_id"
    t.string "placas", limit: 255
    t.integer "nacionalidad_id"
    t.string "direccion_accidente", limit: 255
    t.string "medio_llegada", limit: 255
    t.integer "arl_id"
    t.string "nombre_concatenado", limit: 255
  end

  create_table "permisos", id: :serial, force: :cascade do |t|
    t.integer "tipo"
    t.string "observacion"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "evento_ambulatorio_id"
    t.integer "crue_user_id"
  end

  create_table "personas", id: :serial, force: :cascade do |t|
    t.string "primer_nombre", limit: 255
    t.string "primer_apellido", limit: 255
    t.string "segundo_nombre", limit: 255
    t.string "segundo_apellido", limit: 255
    t.integer "tipo_doc"
    t.string "numero_id", limit: 255
    t.string "direccion", limit: 255
    t.string "telefono", limit: 255
    t.integer "edad"
    t.integer "sexo"
    t.integer "unidades_edad"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "barrio_id"
    t.string "municipio", limit: 255
  end

  create_table "plan_emergencias", id: :serial, force: :cascade do |t|
    t.date "fecha_simulacion"
    t.date "fecha_simulacro"
    t.text "observacion"
    t.string "nombre_responsable"
    t.string "email_responsable"
    t.string "telefono_responsable"
    t.integer "crue_user_id"
    t.integer "municipio_id"
    t.integer "institucion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "primer_respondientes", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "updated_position_at"
    t.string "primer_nombre"
    t.string "segundo_nombre"
    t.string "primer_apellido"
    t.string "segundo_apellido"
    t.string "cedula"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "telefono"
    t.date "fecha_nacimiento"
    t.text "descripcion"
    t.string "uuid"
    t.date "fecha_vigencia"
    t.string "url"
    t.datetime "last_updated_at"
    t.integer "cantidad_notificados"
    t.boolean "disponible", default: false
    t.index ["email"], name: "index_primer_respondientes_on_email", unique: true
    t.index ["reset_password_token"], name: "index_primer_respondientes_on_reset_password_token", unique: true
  end

  create_table "prioridads", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procedimientos", id: :serial, force: :cascade do |t|
    t.string "codigo"
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proyectos", id: :serial, force: :cascade do |t|
    t.integer "municipio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "puntos", id: :serial, force: :cascade do |t|
    t.integer "zona_id"
    t.float "latitude"
    t.float "longitude"
  end

  create_table "registro_pdfs", id: :serial, force: :cascade do |t|
    t.string "tipo_documento"
    t.string "numero_documento"
    t.integer "enumeracion_resultado"
    t.text "observacion_resultado"
    t.integer "muestra_id"
    t.integer "cargue_masivo_pdf_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registros", id: :serial, force: :cascade do |t|
    t.string "tipo_documento"
    t.string "numero_documento"
    t.integer "enumeracion_resultado"
    t.text "observacion_resultado"
    t.integer "muestra_id"
    t.integer "cargue_masivo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "remisions", id: :serial, force: :cascade do |t|
    t.integer "estado"
    t.integer "institucion_emisor_id"
    t.integer "institucion_receptor_id"
    t.integer "super_remision_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "respondido_at"
  end

  create_table "reunions", id: :serial, force: :cascade do |t|
    t.text "titulo"
    t.text "descripcion"
    t.datetime "fecha"
    t.integer "caso_salud_publica_id"
    t.integer "medico_id"
    t.integer "usuario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "zoom_uuid"
    t.string "zoom_id"
    t.string "zoom_host_id"
    t.text "zoom_start_url"
    t.text "zoom_join_url"
    t.string "zoom_password"
    t.string "opentok_session_id"
    t.string "opentok_participant_token"
    t.string "opentok_host_token"
    t.string "uuid", limit: 255
  end

  create_table "salud_mental_casos", id: :serial, force: :cascade do |t|
    t.date "fecha"
    t.string "primer_nombre_solicitante"
    t.string "primer_apellido_solicitante"
    t.string "segundo_nombre_solicitante"
    t.string "segundo_apellido_solicitante"
    t.string "parentesco_solicitante"
    t.string "primer_nombre"
    t.string "primer_apellido"
    t.string "segundo_nombre"
    t.string "segundo_apellido"
    t.string "tipo_identificacion"
    t.string "numero_documento"
    t.integer "sexo"
    t.date "fecha_nacimiento"
    t.text "causa"
    t.string "lugar"
    t.text "motivo"
    t.text "observacion"
    t.string "seguridad_social"
    t.integer "estado"
    t.integer "entidad_prestadora_id"
    t.integer "crue_user_id"
    t.integer "hospital_user_id"
    t.integer "institucion_id"
    t.integer "municipio_id"
    t.integer "departamento_caso_id"
    t.integer "municipio_caso_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sancions", id: :serial, force: :cascade do |t|
    t.integer "minutos"
    t.text "descripcion"
    t.integer "ambulancia_id"
    t.integer "evento_ambulatorio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "municipio_id"
    t.boolean "aprobada"
    t.date "fecha_limite"
  end

  create_table "seguimiento_casos", id: :serial, force: :cascade do |t|
    t.string "contenido"
    t.integer "caso_salud_publica_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "usuario_id"
    t.boolean "asintomatico"
    t.boolean "tos"
    t.boolean "dificultad_respiratoria"
    t.boolean "odinofagia"
    t.boolean "fatiga"
    t.boolean "temperatura"
    t.boolean "llamada_fallida"
    t.boolean "crue", default: false
  end

  create_table "seguimiento_evento_ambulatorios", id: :serial, force: :cascade do |t|
    t.string "contenido"
    t.integer "evento_ambulatorio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "crue_user_id"
    t.integer "ingreso_id"
  end

  create_table "seguimientos", id: :serial, force: :cascade do |t|
    t.text "contenido"
    t.integer "super_remision_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servicioinscripcions", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servicios", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "servicios_vigilancias", id: false, force: :cascade do |t|
    t.integer "id", default: -> { "nextval('servicios_id_seq'::regclass)" }, null: false
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sitioeventos", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "soats", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "solicituds", id: :serial, force: :cascade do |t|
    t.integer "institucion_id"
    t.integer "remision_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscripcions", id: :serial, force: :cascade do |t|
    t.text "endpoint"
    t.text "auth"
    t.text "p256dh"
    t.integer "crue_user_id"
    t.integer "hospital_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "super_remisions", id: :integer, default: -> { "nextval('solicitud_camas_id_seq'::regclass)" }, force: :cascade do |t|
    t.text "descripcion"
    t.integer "estado"
    t.integer "hospital_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "institucion_emisor_id"
    t.integer "institucion_receptor_id"
    t.text "respuesta"
    t.integer "categoria_referencia_id"
    t.integer "crue_user_id"
    t.integer "nivel"
    t.string "numero_identificacion", limit: 255
    t.integer "edad"
    t.string "nombre_completo", limit: 255
    t.text "diagnostico"
    t.integer "tipo_documento"
    t.text "contrareferencia"
    t.integer "municipio_id"
    t.integer "diagnostico_id"
    t.integer "entidad_prestadora_id"
    t.integer "ingreso_id"
    t.datetime "fecha_auditoria_eps"
    t.datetime "fecha_auditoria_crue"
    t.datetime "fecha_aprobacion_institucion"
    t.datetime "fecha_cierre"
    t.integer "auditor_eps_id"
    t.integer "auditor_crue_id"
    t.integer "auditor_asignacion_institucion_id"
    t.integer "auditor_cierre_id"
    t.integer "municipio_pagador_id"
    t.datetime "aprobado_at"
    t.string "motivo_rechazo", limit: 255
    t.datetime "rechazado_at"
    t.integer "departamento_id"
    t.integer "municipio_crack_eps_id"
    t.integer "departamento_crack_eps_id"
    t.integer "departamento_pagador_id"
  end

  create_table "superadmins", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_superadmins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_superadmins_on_reset_password_token", unique: true
  end

  create_table "suspencions", id: :serial, force: :cascade do |t|
    t.text "observacion"
    t.integer "ambulancia_id"
    t.date "fecha_limite"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sustancias", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.string "categoria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_camas", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tipo_toxicos", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nombre", limit: 255
  end

  create_table "toxicologia_casos", id: :serial, force: :cascade do |t|
    t.string "categoria"
    t.string "primer_nombre"
    t.string "primer_apellido"
    t.string "segundo_nombre"
    t.string "segundo_apellido"
    t.string "tipo_identificacion"
    t.string "numero_documento"
    t.integer "sexo"
    t.date "fecha_nacimiento"
    t.boolean "esta_en_embarazo"
    t.string "direccion"
    t.string "telefono"
    t.string "nombre_contacto"
    t.string "telefono_contacto"
    t.integer "estado"
    t.integer "crue_user_id"
    t.integer "institucion_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "descripcion"
    t.integer "municipio_id"
    t.integer "hospital_user_id"
    t.integer "entidad_prestadora_id"
    t.string "lugar", limit: 255
    t.integer "sustancia_id"
  end

  create_table "toxicos", id: :serial, force: :cascade do |t|
    t.integer "tipo_toxico_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nombre", limit: 255
  end

  create_table "traslados", id: :serial, force: :cascade do |t|
    t.integer "estado"
    t.datetime "entregado_at"
    t.integer "crue_user_id"
    t.integer "hospital_user_id"
    t.integer "ingreso_id"
    t.integer "institucion_emisora_id"
    t.integer "institucion_receptora_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ambulancia_id"
    t.integer "empresa_ambulancia_id"
    t.datetime "anulado_at"
    t.integer "entidad_prestadora_id"
    t.datetime "aceptado_at"
    t.datetime "paciente_entregado_at"
    t.datetime "paciente_recogido_at"
    t.string "nombre_quien_recibe", limit: 255
    t.string "cedula_quien_recibe", limit: 255
    t.string "observacion_final", limit: 255
    t.datetime "paciente_confirmado_at"
  end

  create_table "tripulantes", id: :serial, force: :cascade do |t|
    t.string "nombre"
    t.string "cedula", default: "", null: false
    t.integer "tipo"
    t.integer "empresa_ambulancia_id"
    t.integer "ambulancia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "retirado", default: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["cedula"], name: "index_tripulantes_on_cedula", unique: true
    t.index ["reset_password_token"], name: "index_tripulantes_on_reset_password_token", unique: true
  end

  create_table "ubicacions", force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.float "accuracy"
    t.float "speed"
    t.string "provider"
    t.boolean "is_mock"
    t.string "gps_location"
    t.string "gps_permission"
    t.string "gps_providers"
    t.string "gps_status"
    t.integer "operario_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "primer_respondiente_id"
  end

  create_table "urgencias", id: :integer, default: nil, force: :cascade do |t|
    t.integer "hospital_id"
    t.integer "hospital_user_id"
    t.integer "paciente_id"
    t.integer "tipourgencia_id"
    t.integer "evolucion_id"
    t.integer "barrio_id"
    t.datetime "fecha_reporte"
    t.text "descripcion_hecho"
    t.text "escenario_hecho"
    t.text "direccion_hecho"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "crue_user_id"
  end

  create_table "usuario_apis", force: :cascade do |t|
    t.string "nombre"
    t.string "descripcion"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "departamento_id"
    t.integer "municipio_id"
    t.integer "version"
  end

  create_table "usuarios", id: :integer, default: -> { "nextval('crue_users_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "primer_nombre", limit: 255
    t.string "segundo_nombre", limit: 255
    t.string "primer_apellido", limit: 255
    t.string "segundo_apellido", limit: 255
    t.string "roles", limit: 255
    t.string "identificacion", limit: 255
    t.datetime "fecha_vigencia"
    t.boolean "activo"
    t.string "cargo", limit: 255
    t.string "telefono", limit: 255
    t.string "celular", limit: 255
    t.integer "empresa_ambulancia_id"
    t.boolean "es_super_admin"
    t.integer "municipio_id"
    t.integer "departamento_id"
    t.integer "usuario_id"
    t.string "xmpp_id", limit: 255
    t.boolean "usuario_principal_chat"
    t.integer "institucion_id"
    t.integer "entidad_prestadora_id"
    t.integer "laboratorio_id"
    t.integer "municipio_alterno_id"
    t.integer "departamento_alterno_id"
    t.string "zoom_id", limit: 255
    t.boolean "zoom_activated"
    t.index ["email"], name: "index_crue_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_crue_users_on_reset_password_token", unique: true
  end

  create_table "variables", id: :serial, force: :cascade do |t|
    t.string "tag"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "zona_cardioprotegidas", id: :serial, force: :cascade do |t|
    t.float "latitude"
    t.float "longitude"
    t.string "ubicacion"
    t.integer "cantidad_dea"
    t.string "telefono_responsable"
    t.integer "cantidad_personas_entrenadas"
    t.string "tipo"
    t.date "fecha_activacion"
    t.date "fecha_vencimiento"
    t.string "nombre"
    t.string "nombre_responsable"
    t.string "telefono"
    t.integer "municipio_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "zonas", id: :serial, force: :cascade do |t|
    t.integer "municipio_id"
  end

end
