class PdfRecord < ActiveRecord::Base
  belongs_to :attachment, optional: true
  belongs_to :sample, optional: true
  belongs_to :pdf_batch, optional: true

  enum result: [
    :success, 
    :id_not_found, 
    :sample_pending, 
    :sample_pending_for_current_lab,
    :more_than_one_pending,
    :invalid_filename,
    :text_migration_failed
  ]

  def class_value
    result == :success ? "table-success" : "table-danger"
  end

end
