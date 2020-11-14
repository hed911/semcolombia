CURRENT_APP_VERSION = "0.0.1".freeze
CURRENT_APP_DATE = "2017/12/29".freeze

PUBLIC_KEY_VAPID_CRUE = "BGu2CS13ame7HbmwWnwc7mf5ZW-ZtB5DG9JWDbLxUhhtfUATQ0LVbm6sm1x0ZyMDv7F4LkTzh8mrjf5gqBet-JQ=".freeze
PRIVATE_KEY_VAPID_CRUE = "he1eBBF7kKysmBIWALX4CSFXrI1w14OfuvMTbZpkccU=".freeze

MUNICIPIO_ID = 27
TIMEOUT_CANCELAR_EVENTO = 1
TIMEOUT_CONFIRMACION_AMBULANCIA = 3
CANTIDAD_AMBULANCIAS_A_NOTIFICAR = 5
HORAS_SANCION = 1
TIEMPO_LIMITE_CONFIRMAR_PACIENTE = 1 # EN HORAS
TIMEOUT_ACEPTAR_CASO = 2.0 #MINUTOS
DIAS_VENCIMIENTO_INGRESOS = 7

COMPLEJIDAD_BAJA = 1
COMPLEJIDAD_MEDIA = 2
COMPLEJIDAD_ALTA = 3

MAX_MINUTOS_INACTIVIDAD = 5
MAX_DISTANCE_BETWEEN_AMBULANCE_AND_PATIENT = 5000 #METROS
MUNICIPIO_PROYECTO_ID = 27 #CARTAGENA ID
MUNICIPIO_PROYECTO_NOMBRE = "cartagena"
DOMINIO_PROYECTO_URL = ""
DOMINIO_PROYECTO_ALCALDIA_URL = "http://www.cartagena.gov.co/"
EMAIL_PROYECTO_CRUE = "solicitudsem@cartagena.gov.co"
DOMINIO_PROYECTO_CRUE = "https://sem-colombia-v2.herokuapp.com"
DOMINIO_PROYECTO_HOSPITAL = "https://sem-colombia-v2.herokuapp.com"
DOMINIO_PROYECTO_CRUE_V2 = DOMINIO_PROYECTO_CRUE[8..(DOMINIO_PROYECTO_CRUE.length - 1)]
DOMINIO_PROYECTO_HOSPITAL_V2 = DOMINIO_PROYECTO_HOSPITAL[8..(DOMINIO_PROYECTO_HOSPITAL.length - 1)]
EMAILS_NOTIFICACION_COVID = ["hedu911@gmail.com", "at_salud@barranquilla.gov.co", "director@barranquillasegura.com"]

JWT_ZOOM = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6InZtczBNeGpUUXUtTjlmcGVtQ3hwZVEiLCJleHAiOjE3MzU3MDc2MDAsImlhdCI6MTU5MDI3Njc4NX0.zgScGnhGTObCcfAUJp09iZRn7wazNdExBT2iApL24Sc"
ZOOM_USER_ID = "9-dGQNgRSwOaZ0ErLIB8Mg"

COLORFUL_THS = %w[
  F6722B
  C7CE34
  2DA300
  D602D5
  3293C5
  0F4D88
  6E6EC8
  8E67D1
].freeze

ROLES = [
  { id: 1, nombre: "Configuracion", enabled: true },
  { id: 2, nombre: "Urgencias", enabled: false },
  { id: 3, nombre: "Recursos", enabled: false },
  { id: 4, nombre: "Salud publica", enabled: true },
  { id: 5, nombre: "Call center", enabled: true },
  { id: 6, nombre: "Solo consultas", enabled: true },
  { id: 7, nombre: "Super", enabled: true },
  { id: 8, nombre: "Sala de analisis de riesgo", enabled: true },
  { id: 9, nombre: "Teleconsulta", enabled: true },
].freeze

ROLES_ENTIDADES_PRESTADORAS = [
  { id: 1, nombre: "Crea casos de Salud publica", enabled: true },
].freeze

ROLES_USUARIOS_ENTIDADES_PRESTADORAS = [
  { id: 1, nombre: "Admin Red de urgencias", enabled: true },
  { id: 2, nombre: "Consultas", enabled: false },
  { id: 3, nombre: "Gestion de Usuarios", enabled: true },
  { id: 4, nombre: "Salud publica", enabled: true },
].freeze

ROLES_INSTITUCIONES = [
  { id: 1, nombre: "Crea urgencias", enabled: false },
  { id: 2, nombre: "Gestiona recursos", enabled: false },
  { id: 3, nombre: "Crea casos de Salud publica", enabled: true },
].freeze

ROLES_USUARIOS_INSTITUCIONES = [
  { id: 1, nombre: "Urgencias", enabled: false },
  { id: 2, nombre: "Recursos", enabled: false },
  { id: 3, nombre: "Gestion de Usuarios", enabled: true },
  { id: 4, nombre: "Salud publica", enabled: true },
].freeze

# PRIMER RESPONDIENTE CONSTANTES
MAX_DISTANCE_PRIMER_RESPONDIENTE = 15000 #METROS
MAX_TIME_PRIMER_RESPONDIENTE = 40 #MINUTES
VENCIMIENTO_CASO_PRIMER_RESPONDIENTE = 120 #DESPUES DE X MINUTOS
TIMEOUT_VISUALIZAR_SEGUIMIENTOS = 3 # MINUTES
# PRIMER RESPONDIENTE CONSTANTES

TIPO_INGRESO_AMBULANCIA = 1
TIPO_INGRESO_EXTERNO = 2
TIPO_INGRESO_CONTRARREFERENCIA = 3
TIPO_INGRESO_PPNA = 4

EMAILS_TRANSMETRO = []
TELEFONOS_TRANSMETRO = []

# TIPO RECEPTOR PUSH
CRUE = 1
HOSPITAL = 2

# CLASIFICACION EVENTO
TIPO_WEB = 1
TIPO_APP = 2
TIPO_JUEGOS = 3

# ENUM PUSH
NUEVA_EMERGENCIA = 1
NUEVA_NOVEDAD = 2
NUEVA_SANCION = 3
NUEVA_ALERTA_ROJA = 4
TRASLADO_HABILITADO = 5

# ENUM PUSHER
TEXT_RECEIVED = 1
TEXT_SENT = 2
IMAGE_RECEIVED = 3
IMAGE_SENT = 4

# TIPO GPS
GPS_MOVIL = 1
GPS_AMBULANCIA = 2

# ENUM CUMPLIMIENTO
CUMPLIMIENTO_PENDIENTE = 1
CUMPLIMIENTO_APROBADO = 2
CUMPLIMIENTO_DENEGADO = 3
CUMPLIMIENTO_POR_FUERA_DE_MUNICIPIO = 4
CUMPLIMIENTO_CANCELADO = 5

MOTIVO_CANCELACION_FALSA_ALARMA = 1
MOTIVO_CANCELACION_PACIENTE_FALLECIDO = 2
MOTIVO_CANCELACION_FALLA_MECANICA = 3
MOTIVO_CANCELACION_ME_ACCIDENTE = 4
MOTIVO_CANCELACION_OTRO = 5

# ENUM ESTADOS
ESTADO_PENDIENTE = 1
ESTADO_AMBULANCIA_CONFIRMADA = 2
ESTADO_PACIENTE_RECOGIDO = 3
ESTADO_PACIENTE_LLEVADO_A_HOSPITAL = 4
ESTADO_PACIENTE_CONFIRMADO_EN_HOSPITAL = 5
ESTADO_CANCELADO = 6
ESTADO_TRASLADADO = 7
ESTADO_PENDIENTE_POR_AUTORIZAR = 8

# TIPOS TU RED
TIPO_TU_RED_HOGAR = 1
TIPO_TU_RED_TRANSITO = 2
TIPO_TU_RED_ARL = 3
TIPO_TU_RED_PARTICULAR = 4
TIPO_TU_RED_PREPAGADA = 5

# ENUM ESTADOS
ESTADO_SP_VIGENTE = 1
ESTADO_SP_CERRADO = 2

USUARIOS_WS_SISMUESTRA = [
  {
    municipio_id: 4,
    username: "wsbarranquilla@ws",
    password: "YM4YAqJQuR94schg",
  },
  {
    municipio_id: 27,
    username: "wscartagena@ws",
    password: "hE5EHhQXtUQnFXuz",
  },
  {
    municipio_id: 1988,
    username: "wsatlantico@ws",
    password: "gqxUE6Fvs9JP6G7H",
  },
]

PDF_ENABLED = true
