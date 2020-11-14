
module XmppHelper

  def self.crear_usuario(username)
    params = {
      nickname:username
    }
    puts "PARAMS:#{params.to_json}"
    response = HTTParty.post("#{ENV['xmpp_url']}/api/usuarios",
    {
      body: params.to_json.to_s,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    print "RESPUESTA:#{response}"
    response.code == 200
  end

  def self.crear_grupo(id)
    params = {
      id:id
    }
    response = HTTParty.post("#{ENV['xmpp_url']}/api/grupos",
    {
      body: params.to_json.to_s,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    response.code == 200
  end

  def self.agregar_miembro_grupo(id, username) 
    params = {
      nickname:username
    }
    response = HTTParty.put("#{ENV['xmpp_url']}/api/grupos/#{id}/agregar_miembro",
    {
      body: params.to_json.to_s,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    response.code == 200
  end

  def self.borrar_grupo(id)
    params = {}
    response = HTTParty.delete("#{ENV['xmpp_url']}/api/grupos/#{id}",
    {
      body: params.to_json.to_s,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    response.code == 200
  end

  def self.agregar_contacto(username_from, username_to)
    params = {
      username:username_to
    }
    response = HTTParty.put("#{ENV['xmpp_url']}/api/usuarios/#{username_from}/agregar_contacto",
    {
      body: params.to_json.to_s,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    })
    response.code == 200
  end
end
