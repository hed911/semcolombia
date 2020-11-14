module FaradayOverrides
  def initialize *args
    options = args.last
    options[:ssl] = {verify: false}
    super
  end
end

module CasoPoliciaHelper
  include XmppHelper
  def self.cerrar(caso)
body = <<-FOO
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://policia.gov.co/webservice">
   <soapenv:Header/>
   <soapenv:Body>
      <web:VerToken>
         <!--Optional:-->
         <web:pLogin>
            <!--Optional:-->
            <web:_vUsuario>SALUD.MEBAR</web:_vUsuario>
            <!--Optional:-->
            <web:_vPassword>81E96BB644EEE4AA9B843FA7C46A5804</web:_vPassword>
            <!--Optional:-->
            <web:_vToken>?</web:_vToken>
         </web:pLogin>
      </web:VerToken>
   </soapenv:Body>
</soapenv:Envelope>
FOO
    Faraday::Connection.prepend FaradayOverrides
    conn = Faraday.new(:url => 'https://logmqa.policia.gov.co:8090/Service1.asmx')
    result = conn.post do |req|
      req.url 'https://logmqa.policia.gov.co:8090/Service1.asmx'
      req.headers['Content-Type'] = 'text/xml'
      req.body = body
    end
    result = XmlHasher.parse(result.body)
    token = result[:"soap:Envelope"][:"soap:Body"][:"VerTokenResponse"][:"VerTokenResult"][:"_vToken"]
body = <<-FOO
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://policia.gov.co/webservice">
   <soapenv:Header/>
   <soapenv:Body>
      <web:CierreEvento>
         <!--Optional:-->
         <web:pCierre>
            <!--Optional:-->
            <web:_vSitioGraba>4</web:_vSitioGraba>
            <!--Optional:-->
            <web:_vNumeLlamada>#{caso.codigo_llamada}</web:_vNumeLlamada>
            <!--Optional:-->
            <web:_vFuerza>60034011</web:_vFuerza>
            <!--Optional:-->
            <web:_vCanal>4</web:_vCanal>
            <!--Optional:-->
            <web:_vRecursoAt>SIN_AMBULANCIA</web:_vRecursoAt>
            <!--Optional:-->
            <web:_vHoraRuta></web:_vHoraRuta>
            <!--Optional:-->
            <web:_vHorallegada></web:_vHorallegada>
            <!--Optional:-->
            <web:_vHoraTermina></web:_vHoraTermina>
            <!--Optional:-->
            <web:_vCasoAtendido>910</web:_vCasoAtendido>
            <!--Optional:-->
            <web:_vClasificacion>01</web:_vClasificacion>
            <!--Optional:-->
            <web:_vAnotacion>#{caso.estado_value}</web:_vAnotacion>
            <!--Optional:-->
            <web:_vUsuario>SALUD.MEBAR</web:_vUsuario>
            <!--Optional:-->
            <web:_vToken>#{token}</web:_vToken>
         </web:pCierre>
      </web:CierreEvento>
   </soapenv:Body>
</soapenv:Envelope>
FOO
    puts "BODY:#{body}"
    conn = Faraday.new(:url => 'https://logmqa.policia.gov.co:8090/Service1.asmx')
    result = conn.post do |req|
      req.url 'https://logmqa.policia.gov.co:8090/Service1.asmx'
      req.headers['Content-Type'] = 'text/xml'
      req.body = body
    end
    result
  end

end
