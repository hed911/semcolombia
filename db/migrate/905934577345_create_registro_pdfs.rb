class CreateRegistroPdfs < ActiveRecord::Migration[5.0]
  def change
    create_table :registro_pdfs do |t|
      t.string                 :tipo_documento
      t.string                 :numero_documento
      t.integer                :enumeracion_resultado
      t.text                   :observacion_resultado
      t.integer                :muestra_id
      t.integer                :cargue_masivo_pdf_id
      t.timestamps
    end
  end
end
