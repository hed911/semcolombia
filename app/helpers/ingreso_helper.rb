module IngresoHelper

  def self.xls_header
    content = <<-FOO
  <?xml version="1.0"?>
    <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"
     xmlns:o="urn:schemas-microsoft-com:office:office"
     xmlns:x="urn:schemas-microsoft-com:office:excel"
     xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
     xmlns:html="http://www.w3.org/TR/REC-html40">
     <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
      <LastAuthor>Microsoft Office User</LastAuthor>
      <Created>2016-08-20T15:03:21Z</Created>
      <LastSaved>2016-08-20T15:01:34Z</LastSaved>
      <Version>15.0</Version>
     </DocumentProperties>
     <OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">
      <AllowPNG/>
      <PixelsPerInch>96</PixelsPerInch>
     </OfficeDocumentSettings>
     <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">
      <WindowHeight>19760</WindowHeight>
      <WindowWidth>38400</WindowWidth>
      <WindowTopX>0</WindowTopX>
      <WindowTopY>460</WindowTopY>
      <ProtectStructure>False</ProtectStructure>
      <ProtectWindows>False</ProtectWindows>
     </ExcelWorkbook>
     <Styles>
       <Style ss:ID="Default" ss:Name="Normal">
         <Alignment ss:Vertical="Bottom"/>
         <Borders/>
         <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="12" ss:Color="#000000"/>
         <Interior/>
         <NumberFormat/>
         <Protection/>
       </Style>
       <Style ss:ID="s63">
         <NumberFormat ss:Format="#,##0"/>
       </Style>
     </Styles>
     <Worksheet ss:Name="Sheet1">
      <Table ss:ExpandedColumnCount="51" x:FullColumns="1"
       x:FullRows="1" ss:DefaultColumnWidth="65" ss:DefaultRowHeight="16">
       <Column ss:Width="80" ss:Span="50"/>
       <Row>
         <Cell><Data ss:Type="String">ID</Data></Cell>
         <Cell><Data ss:Type="String">PLACAS</Data></Cell>
         <Cell><Data ss:Type="String">NUMERO DE ATENCION</Data></Cell>
         <Cell><Data ss:Type="String">TRIAGE</Data></Cell>
         <Cell><Data ss:Type="String">PRIMER NOMBRE</Data></Cell>
         <Cell><Data ss:Type="String">PRIMER APELLIDO</Data></Cell>
         <Cell><Data ss:Type="String">SEGUNDO NOMBRE</Data></Cell>
         <Cell><Data ss:Type="String">SEGUNDO APELLIDO</Data></Cell>
         <Cell><Data ss:Type="String">TIPO DOCUMENTO</Data></Cell>
         <Cell><Data ss:Type="String">NUMERO DOCUMENTO</Data></Cell>
         <Cell><Data ss:Type="String">FECHA NACIMIENTO</Data></Cell>
         <Cell><Data ss:Type="String">NACIONALIDAD</Data></Cell>
         <Cell><Data ss:Type="String">DIRECCION RESIDENCIA HABITUAL</Data></Cell>
         <Cell><Data ss:Type="String">DEPARTAMENTO</Data></Cell>
         <Cell><Data ss:Type="String">MUNICIPIO</Data></Cell>
         <Cell><Data ss:Type="String">TELEFONO</Data></Cell>
         <Cell><Data ss:Type="String">DIRECCION ACCIDENTE</Data></Cell>
         <Cell><Data ss:Type="String">MEDIO LLEGADA</Data></Cell>
         <Cell><Data ss:Type="String">ORIGEN ATENCION</Data></Cell>
         <Cell><Data ss:Type="String">COBERTURA EN SALUD</Data></Cell>
         <Cell><Data ss:Type="String">EAPB</Data></Cell>
         <Cell><Data ss:Type="String">ASEGURADORA</Data></Cell>
         <Cell><Data ss:Type="String">ARL</Data></Cell>
         <Cell><Data ss:Type="String">MOTIVO CONSULTA</Data></Cell>
         <Cell><Data ss:Type="String">DIAGNOSTICO PRINCIPAL</Data></Cell>
         <Cell><Data ss:Type="String">DIAGNOSTICO UNO</Data></Cell>
         <Cell><Data ss:Type="String">DIAGNOSTICO DOS</Data></Cell>
         <Cell><Data ss:Type="String">DIAGNOSTICO TRES</Data></Cell>
         <Cell><Data ss:Type="String">USUARIO IPS</Data></Cell>
         <Cell><Data ss:Type="String">IPS</Data></Cell>
         <Cell><Data ss:Type="String">NUMERO CASO AMBULANCIA</Data></Cell>
         <Cell><Data ss:Type="String">DEPARTAMENTO ACCIDENTE</Data></Cell>
         <Cell><Data ss:Type="String">MUNICIPIO ACCIDENTE</Data></Cell>
         <Cell><Data ss:Type="String">ESTADO CUMPLIMIENTO</Data></Cell>
         <Cell><Data ss:Type="String">OBSERVACION CUMPLIMIENTO</Data></Cell>
         <Cell><Data ss:Type="String">TIPO DE INGRESO</Data></Cell>
         <Cell><Data ss:Type="String">CATEGORIA CASO</Data></Cell>
         <Cell><Data ss:Type="String">MOTIVO CANCELACION</Data></Cell>
         <Cell><Data ss:Type="String">DETALLE CANCELACION</Data></Cell>
         <Cell><Data ss:Type="String">FECHA INGRESO</Data></Cell>
         <Cell><Data ss:Type="String">PACIENTE REMITIDO</Data></Cell>
         <Cell><Data ss:Type="String">REMITIDO A</Data></Cell>
         <Cell><Data ss:Type="String">DESTINO</Data></Cell>
         <Cell><Data ss:Type="String">FECHA ACCIDENTE</Data></Cell>
       </Row>
    FOO
    content.html_safe
  end

  def self.to_xls_row(ingreso)
    evento_ambulatorio = ingreso.evento_ambulatorio
    content = <<-FOO
      <Row>
        <Cell><Data ss:Type="String">#{ingreso.id}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.placas}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.numero_atencion}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.triage}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.primer_nombre}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.primer_apellido}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.segundo_nombre}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.segundo_apellido}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.tipo_documento_value}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.numero_documento}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.fecha_nacimiento}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.nacionalidad.nombre if ingreso.nacionalidad}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.direccion_residencia_habitual}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.departamento_origen.nombre if ingreso.departamento_origen}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.municipio_origen.nombre if ingreso.municipio_origen}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.telefono}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.direccion_accidente}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.medio_llegada.tr('<', '').tr('>','') if ingreso.medio_llegada}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.origen_atencion_value}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.cobertura_salud_value}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.entidad_prestadora.nombre if ingreso.entidad_prestadora}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.aseguradora.nombre if ingreso.aseguradora}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.arl.nombre if ingreso.arl}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.motivo_consulta.tr('<', '').tr('>','') if ingreso.motivo_consulta}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.diagnostico_principal.nombre if ingreso.diagnostico_principal}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.diagnostico_uno.nombre if ingreso.diagnostico_uno}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.diagnostico_dos.nombre if ingreso.diagnostico_dos}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.diagnostico_tres.nombre if ingreso.diagnostico_tres}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.hospital_user.nombre_completo if ingreso.hospital_user}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.institucion.nombre if ingreso.institucion}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.evento_ambulatorio.id if ingreso.evento_ambulatorio}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.departamento_accidente.nombre if ingreso.departamento_accidente}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.municipio_accidente.nombre if ingreso.municipio_accidente}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.estado_cumplimiento_value}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.observacion_cumplimiento.tr('<', '').tr('>','') if ingreso.observacion_cumplimiento}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.tipo_value}</Data></Cell>
        <Cell><Data ss:Type="String">#{evento_ambulatorio.categoria_evento.nombre if evento_ambulatorio && evento_ambulatorio.categoria_evento}</Data></Cell>
        <Cell><Data ss:Type="String">#{evento_ambulatorio.motivo_cancelacion_value if evento_ambulatorio}</Data></Cell>
        <Cell><Data ss:Type="String">#{evento_ambulatorio.motivo_cancelacion if evento_ambulatorio}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.fecha_ingreso.strftime '%d %b %Y %l:%M %p' if ingreso.fecha_ingreso}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.paciente_remitido ? "SI" : "NO"}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.institucion_remitente.nombre if ingreso.institucion_remitente}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.destino_value}</Data></Cell>
        <Cell><Data ss:Type="String">#{ingreso.fecha_accidente}</Data></Cell>
      </Row>
    FOO
    content.html_safe
  end

  def self.xls_footer
    content = <<-FOO
        </Table>
        <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">
         <PageSetup>
          <Header x:Margin="0.3"/>
          <Footer x:Margin="0.3"/>
          <PageMargins x:Bottom="0.75" x:Left="0.7" x:Right="0.7" x:Top="0.75"/>
         </PageSetup>
         <Print>
         </Print>
         <PageLayoutZoom>0</PageLayoutZoom>
         <Selected/>
         <LeftColumnVisible>6</LeftColumnVisible>
         <Panes>
          <Pane>
           <Number>3</Number>
           <ActiveRow>1</ActiveRow>
           <ActiveCol>16</ActiveCol>
           <RangeSelection>R2C17:R21C17</RangeSelection>
          </Pane>
         </Panes>
         <ProtectObjects>False</ProtectObjects>
         <ProtectScenarios>False</ProtectScenarios>
        </WorksheetOptions>
       </Worksheet>
      </Workbook>
    FOO
    content.html_safe
  end
end
