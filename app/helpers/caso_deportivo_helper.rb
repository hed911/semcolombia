module CasoDeportivoHelper

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
          <Cell><Data ss:Type="String">HOSPITAL</Data></Cell>
          <Cell><Data ss:Type="String">NOTIFICADOR</Data></Cell>
          <Cell><Data ss:Type="String">EVENTO</Data></Cell>
          <Cell><Data ss:Type="String">ESCENARIO</Data></Cell>
          <Cell><Data ss:Type="String">REFERIDO A</Data></Cell>
          <Cell><Data ss:Type="String">TIPO EVENTO</Data></Cell>
          <Cell><Data ss:Type="String">CODIGO DIAGNOSTICO</Data></Cell>
          <Cell><Data ss:Type="String">NOMBRE DIAGNOSTICO</Data></Cell>
          <Cell><Data ss:Type="String">PUESTO ATENCION</Data></Cell>
          <Cell><Data ss:Type="String">TIPO ASISTENTE</Data></Cell>
          <Cell><Data ss:Type="String">NUMERO DOCUMENTO</Data></Cell>
          <Cell><Data ss:Type="String">NOMBRE PACIENTE</Data></Cell>
          <Cell><Data ss:Type="String">EDAD</Data></Cell>
          <Cell><Data ss:Type="String">NACIONALIDAD</Data></Cell>
          <Cell><Data ss:Type="String">DEPARTAMENTO</Data></Cell>
          <Cell><Data ss:Type="String">DISTRITO ESPECIAL</Data></Cell>
          <Cell><Data ss:Type="String">FECHA CREACION</Data></Cell>
        </Row>
    FOO
    content.html_safe
  end

  def self.to_xls_row(caso)
    evento = caso.evento_ambulatorios.first
    content = <<-FOO
      <Row>
        <Cell><Data ss:Type="String">#{caso.id}</Data></Cell>
        <Cell><Data ss:Type="String">#{evento.institucion.nombre if evento && evento.institucion}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.operario.nombre if caso.operario}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.evento_deportivo.nombre if caso.evento_deportivo}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.evento_deportivo.escenario.nombre if caso.evento_deportivo && caso.evento_deportivo.escenario}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.referido_a_value}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.tipo_evento_value}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.diagnostico.codigo if caso.diagnostico}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.diagnostico.nombre if caso.diagnostico}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.puesto_atencion}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.tipo_asistente_value}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.tipo_documento} #{caso.numero_documento}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.nombre_paciente ? caso.nombre_paciente.titleize : nil}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.edad}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.nacionalidad}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.departamento}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.distrito_especial}</Data></Cell>
        <Cell><Data ss:Type="String">#{caso.created_at ? caso.created_at.strftime('%Y-%m-%d') : nil}</Data></Cell>
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
