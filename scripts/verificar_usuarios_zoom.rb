Usuario.where(zoom_activated:[nil, false]).where.not(zoom_id:nil).each do |usuario|
  response = ZoomHelper.get_user(usuario.zoom_id)
  if response[:response]["status"] == "active"
    usuario.zoom_activated = true
    usuario.save!
  end
end
