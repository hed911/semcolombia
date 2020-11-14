class CreateUsuarioApis < ActiveRecord::Migration[5.1]
  def change
    create_table :usuario_apis do |t|
      t.string :nombre
      t.string :descripcion
      t.string :username
      t.string :password_digest

      t.timestamps
    end
  end
end
