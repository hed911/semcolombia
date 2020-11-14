data = []
registros_positivos = CasoSaludPublica.where(municipio:Municipio.find(4), estado_enfermedad:2, publico:true)
registros_positivos.each do |registro|
  data << [registro.longitude, registro.latitude]
end
kmeans = KMeansClusterer.run 10, data
@result = []
kmeans.clusters.each do |cluster|
  @result << {lat:cluster.centroid[1], lng:cluster.centroid[0], count:cluster.points.count}
end
