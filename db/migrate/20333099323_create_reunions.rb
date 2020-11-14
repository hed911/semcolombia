class CreateReunions < ActiveRecord::Migration[5.0]
  def change
    create_table :reunions do |t|
      t.text                     :titulo
      t.text                     :descripcion
      t.datetime                 :fecha
      t.integer                  :caso_salud_publica_id
      t.integer                  :medico_id
      t.integer                  :usuario_id
      t.timestamps
    end
  end
end
