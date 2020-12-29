class PdfBatch < ActiveRecord::Base
  belongs_to :city, optional:true
  belongs_to :user, optional:true
  belongs_to :laboratory, optional:true
  has_many :attachments
  has_many :records, :class_name => 'PdfRecord', :foreign_key => 'pfd_record_id'
  mount_uploader :attachment, TheFileUploader

  enum state: [
    :in_progress, 
    :finished, 
    :error
  ]

  def result_value
    {
      :in_progress => 'EN PROGRESO',
      :finished  => 'TERMINADO',
      :error  => 'ERROR'
    }[result]
  end

  def table_value
    {
      :finished  => 'success',
      :error  => 'danger'
    }[result]
  end

end
