
module XmppHelper

  def self.crear_usuario(username)
    params = {
      nickname:username
    }
    puts "PARAMS:#{params.to_json}"
    response = HTTParty.post("http://156.67.221.152:3000/api/usuarios",
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
    response = HTTParty.post("http://156.67.221.152:3000/api/grupos",
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
    response = HTTParty.put("http://156.67.221.152:3000/api/grupos/#{id}/agregar_miembro",
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
    response = HTTParty.delete("http://156.67.221.152:3000/api/grupos/#{id}",
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
    response = HTTParty.put("http://156.67.221.152:3000/api/usuarios/#{username_from}/agregar_contacto",
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
