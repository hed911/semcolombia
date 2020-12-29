class Contact < ActiveRecord::Base
  self.table_name = 'contacts'
  
  belongs_to :parent, class_name: 'Event', foreign_key: 'parent_id', optional:true
  belongs_to :son, class_name: 'Event', foreign_key: 'son_id', optional:true

  enum contact_type: [
    :family, 
    :in_a_flight, 
    :health_people,
    :waiting_room,
    :social
  ]

  def contact_type_value
    {
      :family  => 'Familiares',
      :in_a_flight => 'De vuelo',
      :health_people => 'Personal de salud o IPS',
      :waiting_room => 'Sala de espera',
      :social => 'Sociales'
    }[state]
  end

end
