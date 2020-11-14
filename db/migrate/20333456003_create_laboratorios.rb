class CreateLaboratorios < ActiveRecord::Migration[5.0]
  def change
    create_table :laboratorios do |t|
      t.string                   :nombre
      t.string                   :direccion
      t.string                   :telefono
      t.string                   :nit
      t.timestamps
    end
  end
end
