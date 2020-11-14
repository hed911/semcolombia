class CreateLlamadas < ActiveRecord::Migration[5.0]
  def change
    create_table :llamadas do |t|
      t.text                     :descripcion
      t.integer                  :intension
      t.integer                  :caso_salud_publica_id
      t.timestamps
    end
  end
end
