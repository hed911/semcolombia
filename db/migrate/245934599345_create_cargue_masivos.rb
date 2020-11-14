class CreateCargueMasivos< ActiveRecord::Migration[5.0]
  def change
    create_table :cargue_masivos do |t|
      t.text                   :errores
      t.string                 :archivo_file_name
      t.string                 :archivo_content_type
      t.integer                :archivo_file_size
      t.datetime               :archivo_updated_at
      t.integer                :cantidad_registros
      t.text                   :Ya_creadas_anteriormente
      t.text                   :creadas
      t.integer                :estado
      t.datetime               :fecha_finalizacion
      t.integer                :oid
      t.string                 :archivo
      t.text                   :errores

      t.integer                :municipio_id
      t.integer                :usuario_id
      t.timestamps
    end
  end
end
