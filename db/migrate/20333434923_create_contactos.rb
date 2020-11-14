class CreateContactos < ActiveRecord::Migration[5.0]
  def change
    create_table :contactos do |t|
      t.string                   :parentezco
      t.integer                  :parent_id
      t.integer                  :son_id
      t.timestamps
    end
  end
end
