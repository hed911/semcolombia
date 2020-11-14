require "resque/server"
Rails.application.routes.draw do
  devise_for :usuarios, controllers: { passwords: "passwords" }

  namespace :api do
    resources :casos do
    end
  end

  resources :usuario_apis do
  end

  # RUTAS GLOBALES
  resources :nacionalidads do
    collection do
      get "search"
    end
  end

  resources :diagnosticos do
    collection do
      get "search"
      post "export_xls"
    end
  end

  resources :departamentos, only: [:index] do
    member do
      get "get_municipios"
    end
  end

  resources :municipios, only: [] do
    member do
      get "get_barrios"
    end
  end

  resources :notificacion_emergentes do
    collection do
      post "search"
    end
  end

  resources :archivos do
    member do
      get "generate_and_download"
    end
  end
  # RUTAS GLOBALES

  namespace :entidad_prestadora do
    resources :tests do
      collection do
        post "search"
        post "download"
      end
      member do
      end
    end
    resources :resultados do
      collection do
        post "search"
        post "search_pendientes"
        post "search_hoy"
      end
      member do
        get "pendientes"
        get "hoy"
      end
    end
    resources :caso_salud_publicas do
      resources :contactos
      resources :muestras do
      end
      collection do
        get "existe"
        post "search"
        post "search_actuales"
        post "search_csv"
        get "dashboard"
      end
      member do
        get "actuales"
        get "edit_ubicacion"
        put "update_ubicacion"
        put "owned"
        get "edit_crue"
        put "update_crue"
      end
    end

    resources :usuarios do
      member do
        get "change_pass"
        patch "do_change_pass"
        patch "update_extend"
        patch "reset_password"
      end
      collection do
        post "export_xls"
      end
    end
  end

  namespace :institucion do
    resources :tests do
      collection do
        post "search"
        post "download"
      end
      member do
      end
    end
    resources :resultados do
      collection do
        post "search"
        post "search_pendientes"
        post "search_hoy"
      end
      member do
        get "pendientes"
        get "hoy"
      end
    end
    resources :caso_salud_publicas do
      resources :seguimiento_casos do
        collection do
          get "descarga"
          post "do_descargar"
        end
      end
      resources :contactos
      resources :muestras do
      end
      collection do
        get "existe"
        post "search"
        post "search_actuales"
        post "search_csv"
        get "dashboard"
        post "download"
      end
      member do
        get "actuales"
        get "edit_ubicacion"
        put "update_ubicacion"
        put "owned"
        get "reasignar_ips"
        put "do_reasignar_ips"
      end
    end

    resources :usuarios do
      collection do
        post "search"
        post "search_xls"
        post "export_xls"
      end
      member do
        get "all"
        get "new_extended"
        post "create_extended"
        get "change_pass"
        patch "do_change_pass"
        patch "reset_password"
      end
    end
  end

  namespace :laboratorio do
    resources :tests do
      collection do
        post "search"
        post "search_pendientes"
        post "search_pendientes_v2"
        get "dashboard"
        post "search_recibidas"
        post "search_despachadas"
        post "download_recibidas"
        post "download_despachadas"
        post "download"
      end
      member do
        get "pendientes"
        get "despachar"
        put "do_despachar"
        get "recibir"
        put "do_recibir"
        put "do_recibir_asignado"
        get "recibidas"
        get "despachadas"
        get "pendientes_v2"
      end
    end
    resources :resultados do
      collection do
        post "search"
        post "search_pendientes"
        post "search_hoy"
      end
      member do
        get "pendientes"
        get "hoy"
      end
    end
    resources :caso_salud_publicas do
      resources :seguimiento_casos
      resources :contactos
      resources :muestras do
        member do
          get "cerrar"
          put "do_cerrar"
        end
      end
      collection do
        get "existe"
        post "search"
        post "search_actuales"
        post "search_csv"
        get "dashboard"
      end
      member do
        get "actuales"
        get "edit_ubicacion"
        put "update_ubicacion"
        put "owned"
      end
    end

    resources :usuarios do
      collection do
        post "search"
        post "search_xls"
        post "export_xls"
      end
      member do
        get "all"
        get "new_extended"
        post "create_extended"
        get "change_pass"
        patch "do_change_pass"
        patch "reset_password"
      end
    end
  end

  namespace :crue do
    resources :cargue_masivos, only: %i[index create show destroy] do
      collection do
        post "search_registros"
      end
    end
    resources :cargue_masivo_pdfs, only: %i[index create show destroy] do
      collection do
        post "search_registros"
        post "search_pendientes"
      end
      member do
        get "pendientes"
        get "resolver"
        put "do_resolver"
      end
    end
    resources :tests do
      collection do
        post "search"
        post "search_pendientes"
        post "search_pendientes_v2"
        post "search_recibidas"
        post "search_despachadas"
        post "search_por_aprobar"
        post "search_inconsistencias"
        post "download_recibidas"
        post "download_despachadas"
        post "download"
        get "busqueda_masiva"
        post "do_busqueda_masiva"
        get "sismuestra_logs"
      end
      member do
        get "por_aprobar"
        get "recibidas"
        get "despachadas"
        get "inconsistencias"
        get "aprobar"
        put "do_aprobar"
        get "pendientes_v2"
      end
    end

    resources :resultados do
      collection do
        post "search"
        post "search_v2"
        post "search_pendientes"
        post "search_hoy"
        get "index_v2"
      end
      member do
        get "pendientes"
        get "hoy"
      end
    end
    resources :intensions do
    end
    resources :llamadas do
      collection do
        post "search"
        post "search_entrantes"
        post "search_pendientes"
      end
      member do
        get "entrantes"
        get "pendientes"
      end
    end
    resources :departamentos, only: [:index] do
      collection do
        post "export_xls"
      end
      resources :users do
        collection do
          post "export_xls"
        end
        member do
          get "change_pass"
          patch "do_change_pass"
          patch "update_extend"
          patch "reset_password"
        end
      end
    end

    resources :municipios, only: [:show] do
      collection do
        post "export_xls"
      end
      member do
        put "set"
        get "edit_cobertura"
        put "update_zonas"
        put "toggle_habilitacion_autorizacion"
        put "toggle_habilitacion_remision"
      end
      resources :usuarios do
        collection do
          post "export_xls"
        end
        member do
          get "change_pass"
          patch "do_change_pass"
          patch "reset_password"
        end
      end
    end

    resources :entidad_prestadoras do
      collection do
        post "export_xls"
      end
      member do
        get "red_urgencia"
        get "get_instituciones_despacho"
        get "get_instituciones_destino"
        put "toggle_habilitacion_hospital"

        get "subir_archivo"
        put "do_subir_archivo"
        put "toggle_habilitacion"
      end
      resources :eps_users do
        collection do
          post "export_xls"
        end
        member do
          get "change_pass"
          patch "do_change_pass"
          patch "reset_password"
        end
      end
    end

    resources :aseguradoras do
      collection do
        post "export_xls"
      end
      resources :aseg_users do
        collection do
          post "export_xls"
        end
        member do
          get "change_pass"
          patch "do_change_pass"
          patch "reset_password"
        end
      end
    end

    resources :super_admins do
      collection do
        post "export_xls"
      end
    end

    resources :variables do
      collection do
        get "sms"
        post "update_sms"
      end
    end

    resources :usuarios do
      member do
        get "change_pass"
        patch "do_change_pass"
        patch "update_extend"
        patch "reset_password"
      end
      collection do
        post "create_extend"
        post "export_xls"
        post "change_my_pass"
      end
    end

    resources :institucions do
      collection do
        get "ips_list"
        post "search"
        post "export_xls"
        post "search_for_escenarios"
        post "search_positions_for_escenarios"
        post "search_csv"
      end

      member do
        get "update_camas"
        put "do_update_camas"
        get "sedes"
      end

      resources :hospital_users do
        collection do
          post "search"
          post "search_xls"
          post "export_xls"
        end
        member do
          get "all"

          get "new_extended"
          post "create_extended"

          get "change_pass"
          patch "do_change_pass"
          patch "reset_password"
        end
      end
    end

    resources :laboratorios do
      collection do
        post "search"
        post "search_csv"
      end
      resources :lab_users do
        collection do
          post "search"
          post "search_csv"
        end
        member do
          get "change_pass"
          patch "do_change_pass"
          patch "reset_password"
        end
      end
    end

    resources :categoria_referencias do
      collection do
        post "search"
        post "export_xls"
      end
      member do
        get "edit_extend"
        put "update_extend"
      end
    end

    resources :eventos_ambulatorios do
      collection do
        post "reverse_geocode"
        post "geocode"
      end
      member do
      end
    end

    resources :historial_recursos do
      collection do
        post "search_allhospitals"
        post "search_hospitals_history"
        post "search_xls"
        post "change_date"
        get "consulta"
        post "do_consulta"
      end
      member do
        get "last_recurso"
      end
    end

    resources :historial_recurso_urgencias do
      collection do
        post "search_allhospitals"
        post "search_hospitals_history"
        post "search_xls"
        post "change_date"
        get "consulta"
        post "do_consulta"
      end
      member do
        get "last_recurso"
      end
    end

    resources :historial_urgencias do
      collection do
        post "search_allhospitals"
        post "search_hospitals_history"
        post "search_xls"
        post "change_date"
        get "consulta"
        post "do_consulta"
      end
      member do
        get "last_recurso"
      end
    end

    resources :caso_salud_publicas do
      resources :reunions do
        collection do
          post "search_pendientes"
        end
        member do
          get "pendientes"
        end
      end
      resources :seguimiento_casos
      resources :desplazamientos
      resources :consultas
      resources :muestras do
        member do
          get "cerrar"
          put "do_cerrar"
        end
      end
      resources :contactos do
        member do
          delete "desenlazar"
        end
      end
      collection do
        get "existe"
        post "search"
        post "search_actuales"
        post "search_csv"
        get "dashboard"
        get "dashboard_v2"
        get "dashboard_v3"
        get "dashboard_v4"
        get "dashboard_v5"
        post "download"
        post "search_sin_datos"
      end
      member do
        get "sin_datos"
        get "actuales"
        get "edit_ubicacion"
        put "update_ubicacion"
        get "cerrar"
        put "do_cerrar"
        put "owned"
        get "edit_crue"
        put "update_crue"
        get "agregar_contacto"
        put "do_agregar_contacto"
        get "edit_iec"
        put "update_iec"
        get "pdf_iec"
        get "download_iec_v2"
        get "gestacion"
        put "update_gestacion"
      end
    end

    resources :operarios do
      collection do
        post "search"
        post "export_xls"
        get "list"
        get "actuales"
        get "visor"
        get "historial"
        post "search_positions"
        get "habilitados"
      end
    end
  end

  get "custom_change_pass" => "static#custom_change_pass"
  root to: "inicio#index"
  put "/set_institucion/:id" => "dashboard#set_institucion", :as => "set_institucion"
  get "/custom_route/sedes_json/:id" => "hospitals#sedes_json", as: :sedes_json
  get "dashboard" => "dashboard#index", :as => "dashboard"
  get "notifications_panel" => "dashboard#notifications_panel", :as => "notifications_panel"
  post "mark_as_read" => "dashboard#mark_as_read", :as => "mark_as_read"
  get "ambulancias_dashboard" => "dashboard#ambulancias", :as => "ambulancias_dashboard"
  get "dashboard_por_ips" => "dashboard#dashboard_por_ips", :as => "dashboard_por_ips"
  get "dashboard_por_ambulancia" => "dashboard#dashboard_por_ambulancia", :as => "dashboard_por_ambulancia"
  get "dashboard_por_tipo" => "dashboard#dashboard_por_tipo", :as => "dashboard_por_tipo"
  get "dashboard_por_ips_ambulancia" => "dashboard#dashboard_por_ips_ambulancia", :as => "dashboard_por_ips_ambulancia"
  get "dashboard_por_ips_categoria_evento" => "dashboard#dashboard_por_ips_categoria_evento", :as => "dashboard_por_ips_categoria_evento"
  get "dashboard_conexiones" => "dashboard#dashboard_conexiones", :as => "dashboard_conexiones"
  get "inicio" => "inicio#index", :as => "inicio"
  get "crack" => "inicio#crack", :as => "crack"
  get "profile" => "dashboard#profile", :as => "profile"

  get "consulta" => "dashboard#consulta", :as => "consulta"
  post "consulta" => "dashboard#do_consulta", :as => "do_consulta"

  get "consulta_barranquilla" => "dashboard#consulta_barranquilla", :as => "consulta_barranquilla"
  post "do_consulta_barranquilla" => "dashboard#do_consulta_barranquilla", :as => "do_consulta_barranquilla"

  get "consulta_soledad" => "dashboard#consulta_soledad", :as => "consulta_soledad"
  post "do_consulta_soledad" => "dashboard#do_consulta_soledad", :as => "do_consulta_soledad"

  get "consulta_cartagena" => "dashboard#consulta_cartagena", :as => "consulta_cartagena"
  post "do_consulta_cartagena" => "dashboard#do_consulta_cartagena", :as => "do_consulta_cartagena"

  get "consulta_monteria" => "dashboard#consulta_monteria", :as => "consulta_monteria"
  post "do_consulta_monteria" => "dashboard#do_consulta_monteria", :as => "do_consulta_monteria"

  get "consulta_atlantico" => "dashboard#consulta_atlantico", :as => "consulta_atlantico"
  post "do_consulta_atlantico" => "dashboard#do_consulta_atlantico", :as => "do_consulta_atlantico"

  get "/manuales" => "static#manuales", as: :manuales
  get "/credentials_url" => "static#credentials_url", as: :credentials_url

  post "/api/auth/login" => "api/authentication#login", as: :auth_login
  mount ExtraExtra::Engine, at: "/release_notes"

  get "/.well-known/pki-validation/725CBC59BE102B7BE22E6B3CC48EF43B.txt" => "dashboard#cosa_ssl", :as => "cosa_ssl"

  authenticate :usuario do
    mount Resque::Server, at: "/resque"
  end
end
