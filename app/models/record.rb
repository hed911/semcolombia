class Record < ActiveRecord::Base
  belongs_to :sample, optional: true
  belongs_to :batch, optional: true

  enum result: [
    :success, 
    :repeated, 
    :error
  ]

  def result_value
    {
      :success => 'REGISTRO CREADO EXITOSAMENTE',
      :repeated  => 'REGISTRO REPETIDO',
      :error  => 'OTRO ERROR'
    }[result]
  end

  def class_value
    {
      :success => 'success',
      :repeated  => 'danger',
    }[result]
  end

end
