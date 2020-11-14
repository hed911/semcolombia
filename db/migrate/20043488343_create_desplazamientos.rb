class CreateDesplazamientos < ActiveRecord::Migration[5.0]
  def change
    create_table :desplazamientos do |t|
      t.text                   :contenido
      t.integer                :caso_salud_publica_id
      t.integer                :usuario_id
      t.timestamps
    end
  end
end
