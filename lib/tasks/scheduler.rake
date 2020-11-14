task verificar_usuarios: :environment do
  load "scripts/verificar_usuarios_zoom.rb"
end
task aprobar_positivos: :environment do
  load "scripts/aprobar_positivos.rb"
end
task migrar_sismuestra: :environment do
  Resque.enqueue StartMigracionSismuestraJob
end
