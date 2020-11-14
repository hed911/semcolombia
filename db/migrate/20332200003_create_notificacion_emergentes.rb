class CreateNotificacionEmergentes < ActiveRecord::Migration[5.0]
  def change
    create_table :notificacion_emergentes do |t|
      t.string                   :nombre
      t.integer                  :estado
      t.integer                  :municipio_id
      t.integer                  :entidad_prestadora_id
      t.integer                  :institucion_id
      t.timestamps
    end
  end
end
