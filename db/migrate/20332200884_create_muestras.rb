class CreateMuestras < ActiveRecord::Migration[5.0]
  def change
    create_table :muestras do |t|
      t.string                   :fecha
      t.integer                  :tipo
      t.integer                  :resultado
      t.string                   :otro_tipo
      t.integer                  :laboratorio_id
      t.integer                  :institucion_id
      t.integer                  :caso_salud_publica_id
      t.integer                  :usuario_emisor_id
      t.integer                  :usuario_finalizador_id
      t.timestamps
    end
  end
end
