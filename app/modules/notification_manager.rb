module NotificationManager
  def nueva_remision_for_instituciones(remision)
    Thread.new do
      HospitalUser.where(institucion: remision.institucion_receptor).each do |user|
        next unless user.roles_array.roles_array.include?(ROLES[0])
        user.subscripcions.each do |sub|
          send_push(
            'Nueva remision',
            "##{remision.id}, EMISOR:#{remision.institucion_emisor.nombre}, RECEPTOR:#{remision.institucion_receptor.nombre}",
            'https://crue-valle-hospital.herokuapp.com/remisions',
            sub.endpoint,
            sub.auth,
            sub.p256dh,
            HOSPITAL
          )
        end
      end
    end
  end
end
