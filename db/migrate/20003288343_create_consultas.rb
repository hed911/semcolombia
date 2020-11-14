class CreateConsultas < ActiveRecord::Migration[5.0]
  def change
    create_table :consultas do |t|
      t.string                 :institucion
      t.date                   :fecha
      t.integer                :caso_salud_publica_id
      t.integer                :usuario_id
      t.timestamps
    end
  end
end
