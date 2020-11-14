class CreateBarrios < ActiveRecord::Migration[5.0]
  def change
    create_table :barrios do |t|
      t.string                   :nombre
      t.integer                  :municipio_id
      t.timestamps
    end
  end
end
