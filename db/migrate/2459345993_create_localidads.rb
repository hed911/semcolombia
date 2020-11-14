class CreateLocalidads < ActiveRecord::Migration[5.0]
  def change
    create_table :localidads do |t|
      t.string                   :nombre
      t.timestamps
    end
  end
end
