class Batch < ActiveRecord::Base
  belongs_to :city, optional:true
  belongs_to :user, optional:true
  has_many :event
  has_many :sample
  has_many :records
  
  mount_uploader :attachment, TheFileUploader

  enum state: [
    :in_progress, 
    :finished, 
    :error
  ]

  def state_value
    {
      :in_progress => 'En progreso',
      :finished  => 'Finalizado',
      :error  => 'Error'
    }[state]
  end

  def table_value
    {
      :in_progress  => '',
      :finished => 'success',
      :error => 'danger'
    }[state]
  end

end