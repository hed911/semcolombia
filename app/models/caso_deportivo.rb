class CasoDeportivo < ActiveRecord::Base
  self.table_name = 'caso_deportivos'
=begin
  attr_accessible :puesto_atencion,
                  :fecha_atencion,
                  :tipo_asistente,
                  :tipo_documento,
                  :numero_documento,
                  :nombre_paciente,
                  :edad,
                  :nacionalidad,
                  :departamento,
                  :distrito_especial,
                  :sexo,
                  :direccion_residencia,
                  :barrio,
                  :telefono,
                  :email,

                  :tipo_evento,

                  :lesion_mayor_fractura,
                  :lesion_mayor_dislocacion,
                  :lesion_mayor_lesion_por_aplastamiento,
                  :lesion_mayor_traumatismo,
                  :lesion_mayor_amputacion,
                  :lesion_mayor_lesion_intracraneana,
                  :lesion_mayor_lesion_interna_de_un_organo,
                  :lesion_ahogamiento_por_inmersion,
                  :lesion_mayor_asfixia,
                  :lesion_mayor_quemadura_por_corrosivos,
                  :lesion_mayor_por_electricidad,

                  :tejidos_blandos_esguince,
                  :tejidos_blandos_hematoma,

                  :herida_ampolla,
                  :herida_abrasion,
                  :herida_laceracion_superficial,
                  :herida_herida_abierta,
                  :herida_otra_herida_mayor,

                  :cuerpo_extrano_en_el_exterior_del_ojo,
                  :cuerpo_extrano_en_el_canal_auditivo,
                  :cuerpo_extrano_en_nariz,
                  :cuerpo_extrano_en_las_vias_respiratorias,
                  :cuerpo_extrano_en_el_tracto_digestivo,
                  :cuerpo_extrano_en_las_vias_genitourinarias,
                  :cuerpo_extrano_en_tejido_blando,
                  :cuerpo_extrano_en_sitios_o_lugar_no_especificado,

                  :cara_especificamente_lesion_en_ojo,
                  :cara_especificamente_lesiones_dentales,
                  :cara_especificamente_lesion_en_nariz,

                  :revision_revision_de_la_lesion,
                  :revision_de_mas_de_una_naturaleza,

                  :cabeza_y_cuello_cabeza,
                  :cabeza_y_cuello_cara,
                  :cabeza_y_cuello_cuello,

                  :torax_espina,
                  :torax_espalda,
                  :torax_torax,

                  :abdomen_abdomen,
                  :abdomen_pelvis,

                  :extremidades_hombro,
                  :extremidades_brazo,
                  :extremidades_codo,
                  :extremidades_antebrazo,
                  :extremidades_muneca,
                  :extremidades_mano,
                  :extremidades_muslo,
                  :extremidades_rodilla,
                  :extremidades_pierna,
                  :extremidades_tobillo,
                  :extremidades_pie,
                  :extremidades_multiple_localizaciones,

                  :cardiacos_paro_cardiaco,
                  :cardiacos_dolor_de_pecho,
                  :cardiacos_otro,

                  :respiratorios_paro_respiratorio,
                  :respiratorios_asma,
                  :respiratorios_otro,

                  :neurologicos_convulsion,
                  :neurologicos_colapso_no_especificado,

                  :gastrointestinales_nauseas_vomitos,
                  :gastrointestinales_diarrea,
                  :gastrointestinales_relacionadas_con_diabetes,

                  :menor_dolor_de_cabeza,
                  :menor_piel_rash,
                  :menor_fiebre,
                  :menor_dolor_ocular,
                  :menor_dolor_de_oido,
                  :menor_colico,
                  :menor_debilidad,
                  :menor_mareos,
                  :menor_otro,

                  :relacionadas_con_el_calor_quemaduras_por_el_sol,
                  :relacionadas_con_el_calor_agotamiento,
                  :relacionadas_con_el_calor_sofocacion,

                  :relacionadas_con_el_frio_hipotermia,
                  :relacionadas_con_el_frio_congelacion,

                  :relacionadas_con_drogas_de_abuso_alcohol,
                  :relacionadas_con_drogas_de_abuso_marihuana,
                  :relacionadas_con_drogas_de_abuso_cocaina,
                  :relacionadas_con_drogas_de_abuso_alucinogenos,
                  :relacionadas_con_drogas_de_abuso_extasis,
                  :relacionadas_con_drogas_de_abuso_solventes,
                  :relacionadas_con_drogas_de_abuso_otro,

                  :relacionadas_con_picadura,

                  :agente_causante,

                  :relacionadas_con_alimentos,

                  :agente_causante_de_la_eta,

                  :salud_mental_ansiedad,
                  :salud_mental_trastornos_psiquiatricos,

                  :quimico_espuma_piel,
                  :quimico_espuma_vias_respiratorias,
                  :quimico_espuma_ojos,
                  :quimico_espuma_otro,

                  :lugar_de_la_atencion,
                  :lugar_de_la_atencion_otro,

                  :referido_a,
                  :referido_a_otro,

                  :traslado_ips_fue_en,
                  :traslado_ips_fue_en_otro,

                  :nota
=end
  belongs_to :diagnostico, optional:true
  belongs_to :entidad_prestadora, optional:true
  belongs_to :evento_deportivo, optional:true
  belongs_to :operario, optional:true
  has_many :evento_ambulatorios
  has_many :seguimiento_casos

  def tipo_asistente_value
    if tipo_asistente == 1
      "Participante"
    elsif tipo_asistente == 2
      "Espectador"
    elsif tipo_asistente == 3
      "Logistica"
    elsif tipo_asistente == 4
      "Funcionarios"
    elsif tipo_asistente == 5
      "Gestantes"
    elsif tipo_asistente == 6
      "Deportistas"
    elsif tipo_asistente == 7
      "Otro"
    end
  end

  def sexo_value
    if sexo == "1"
      "Hombre"
    elsif sexo == "2"
      "Mujer"
    end
  end

  def tipo_evento_value
    CasoDeportivo.calculate_tipo_evento(tipo_evento)
  end

  def self.calculate_tipo_evento(string)
    return if string.nil?
    items = []
    string.split(',').each do |item|
      if item == '1'
        items << 'Lesion'
      elsif item == '2'
        items << 'Enfermedad'
      elsif item == '3'
        items << 'Ambiental'
      elsif item == '4'
        items << 'Intoxicaciones'
      elsif item == '5'
        items << 'Salud Mental'
      elsif item == '6'
        items << 'Quimico Espuma'
      elsif item == '7'
        items << 'Consumo Alcohol'
      end
    end
    items.join(',')
  end

  # VALIDAR LOS CEROS COMO EN EL CASO (212)
  # BUSCAR LA FORMA PARA RECORRER TODAS LAS LLAVES DE UN HASH
  # POR CADA VALOR DEL HASH QUE SEA 0 COLOCARLO EN NULL
  # hash.delete_if{|_,v| v == "2"}
  def calculate_tipo_evento_v2()
    tipo_evento_uno = lesion_mayor_fractura || lesion_mayor_dislocacion || lesion_mayor_lesion_por_aplastamiento || lesion_mayor_traumatismo ||
      lesion_mayor_amputacion || lesion_mayor_lesion_intracraneana || lesion_mayor_lesion_interna_de_un_organo ||
      lesion_ahogamiento_por_inmersion || lesion_mayor_asfixia || lesion_mayor_quemadura_por_corrosivos ||
      lesion_mayor_por_electricidad || tejidos_blandos_esguince || tejidos_blandos_hematoma || herida_ampolla ||
      herida_abrasion || herida_laceracion_superficial || herida_herida_abierta || herida_otra_herida_mayor ||
      cuerpo_extrano_en_el_exterior_del_ojo || cuerpo_extrano_en_el_canal_auditivo || cuerpo_extrano_en_nariz ||
      cuerpo_extrano_en_las_vias_respiratorias || cuerpo_extrano_en_el_tracto_digestivo || cuerpo_extrano_en_las_vias_genitourinarias ||
      cuerpo_extrano_en_tejido_blando || cuerpo_extrano_en_sitios_o_lugar_no_especificado || cara_especificamente_lesion_en_ojo ||
      cara_especificamente_lesiones_dentales || cara_especificamente_lesion_en_nariz || revision_revision_de_la_lesion ||
      revision_de_mas_de_una_naturaleza || cabeza_y_cuello_cabeza || cabeza_y_cuello_cara || cabeza_y_cuello_cuello ||
      torax_espina || torax_espalda || torax_torax || abdomen_abdomen || abdomen_pelvis || extremidades_hombro ||
      extremidades_brazo || extremidades_codo || extremidades_antebrazo || extremidades_muneca || extremidades_mano || extremidades_muslo ||
      extremidades_rodilla || extremidades_pierna || extremidades_tobillo || extremidades_pie || extremidades_multiple_localizaciones

    tipo_evento_dos = cardiacos_paro_cardiaco || cardiacos_dolor_de_pecho || cardiacos_otro || respiratorios_paro_respiratorio || respiratorios_asma ||
      respiratorios_otro || neurologicos_convulsion || neurologicos_colapso_no_especificado || gastrointestinales_nauseas_vomitos ||
      gastrointestinales_diarrea || gastrointestinales_relacionadas_con_diabetes || menor_dolor_de_cabeza || menor_piel_rash ||
      menor_fiebre || menor_dolor_ocular || menor_dolor_de_oido  || menor_colico || menor_debilidad || menor_mareos  || menor_otro

    tipo_evento_tres = relacionadas_con_el_calor_quemaduras_por_el_sol || relacionadas_con_el_calor_agotamiento ||relacionadas_con_el_calor_sofocacion ||
      relacionadas_con_el_frio_hipotermia || relacionadas_con_el_frio_congelacion

    tipo_evento_cuatro = relacionadas_con_drogas_de_abuso_alcohol || relacionadas_con_drogas_de_abuso_marihuana || relacionadas_con_drogas_de_abuso_cocaina ||
      relacionadas_con_drogas_de_abuso_alucinogenos || relacionadas_con_drogas_de_abuso_extasis || relacionadas_con_drogas_de_abuso_solventes ||
      relacionadas_con_drogas_de_abuso_otro || relacionadas_con_picadura || agente_causante || relacionadas_con_alimentos || agente_causante_de_la_eta

    tipo_evento_cinco = salud_mental_ansiedad || salud_mental_trastornos_psiquiatricos

    tipo_evento_seis = quimico_espuma_piel || quimico_espuma_vias_respiratorias || quimico_espuma_ojos || quimico_espuma_otro

    result = []
    result << 1 if tipo_evento_uno
    result << 2 if tipo_evento_dos
    result << 3 if tipo_evento_tres
    result << 4 if tipo_evento_cuatro
    result << 5 if tipo_evento_cinco
    result << 6 if tipo_evento_seis
    result.join(",")
  end

  def relacionadas_con_picadura_value
    if relacionadas_con_picadura == 1
      "Leve"
    elsif relacionadas_con_picadura == 2
      "Moderado"
    elsif relacionadas_con_picadura == 3
      "Severo"
    end
  end

  def relacionadas_con_alimentos_value
    if relacionadas_con_alimentos == 1
      "Leve"
    elsif relacionadas_con_alimentos == 2
      "Moderado"
    elsif relacionadas_con_alimentos == 3
      "Severo"
    end
  end

  def lugar_de_la_atencion_value
    if lugar_de_la_atencion == 1
      "MEC"
    elsif lugar_de_la_atencion == 2
      "Transporte asistencial"
    else
      lugar_de_la_atencion_otro
    end
  end

  def referido_a_value
    if referido_a == 1
      "IPS Urgencia"
    elsif referido_a == 2
      "Casa"
    elsif referido_a == 3
      "No referido"
    else
      referido_a_otro
    end
  end

  def traslado_ips_fue_en_value
    if traslado_ips_fue_en == 1
      "Ambulancia Basica"
    elsif traslado_ips_fue_en == 2
      "Ambulancia Medicalizada"
    elsif traslado_ips_fue_en == 3
      "Otro vehiculo de respuesta rapida"
    else
      traslado_ips_fue_en_otro
    end
  end

  def primer_nombre
    nombre_paciente.titleize.split("\s")[0] if nombre_paciente
  end

  def segundo_nombre
    nombre_paciente.titleize.split("\s")[1] if nombre_paciente
  end

  def primer_apellido
    nombre_paciente.titleize.split("\s")[2] if nombre_paciente
  end

  def segundo_apellido
    nombre_paciente.titleize.split("\s")[3] if nombre_paciente
  end

  def estado_seguimiento_value
    if estado_seguimiento == 1
      "EN SEGUIMIENTO"
    elsif estado_seguimiento == 2
      "DE ALTA"
    elsif estado_seguimiento == 3
      "FALLECIDO"
    elsif estado_seguimiento == 4
      "SIN INGRESO"
    end
  end

end
