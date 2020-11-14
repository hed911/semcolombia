require "resque-lock-timeout"
include SisMuestraHelper

class StartMigracionSismuestraJob
  extend Resque::Plugins::LockTimeout
  @queue = :default
  @loner = true
  def self.perform()
    url = "https://apps.ins.gov.co/SisMuestrasApi/api/resultados"
    USUARIOS_WS_SISMUESTRA.each do |usuario_ws|
      municipio = Municipio.find(usuario_ws[:municipio_id])
      token = Base64.encode64("#{usuario_ws[:username]}:#{usuario_ws[:password]}")
      page = 1
      total_pages = nil
      loop do
        response = HTTParty.get("#{url}?pagina=#{page}",
                                {
          body: {},
          headers: {
            'Content-Type': "application/json",
            'Authorization': "Basic #{token}",
          },
        })
        response = response.parsed_response
        next if response["estado"] != "exitoso"
        total_pages = response["totalPaginas"] if total_pages.nil?
        response["datos"].each do |item|
          SisMuestraHelper.parse_item(item, municipio)
        end
        page += 1
        break unless page <= total_pages
      end
    end
  end
end
