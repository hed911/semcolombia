class CreateCargueMasivoPdfs < ActiveRecord::Migration[5.0]
  def change
    create_table :cargue_masivo_pdfs do |t|
      t.text                   :errores
      t.string                 :archivo_file_name
      t.string                 :archivo_content_type
      t.integer                :archivo_file_size
      t.datetime               :archivo_updated_at
      t.integer                :cantidad_registros
      t.integer                :creadas
      t.integer                :estado
      t.integer                :oid
      t.string                 :archivo
      t.integer                :municipio_id
      t.integer                :usuario_id
      #t.bytea                  :file_contents
      t.timestamps
    end
  end
end
