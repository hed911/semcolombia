CasoSaludPublica.where(created_at:(Time.now.beginning_of_day - 2.days)..Time.now).each do |caso|
  results = Geocoder.search("#{caso.direccion} Cartagena")
  next unless results.any?
  caso.latitude = results.first.coordinates[0]
  caso.longitude = results.first.coordinates[1]
  caso.save!
end
