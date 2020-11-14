module InstitucionHelper

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
          <Cell><Data ss:Type="String">CODIGO</Data></Cell>
          <Cell><Data ss:Type="String">NUMERO SEDE</Data></Cell>
          <Cell><Data ss:Type="String">NOMBRE</Data></Cell>
          <Cell><Data ss:Type="String">DIRECCION</Data></Cell>
          <Cell><Data ss:Type="String">TELEFONO</Data></Cell>
          <Cell><Data ss:Type="String">EMAIL</Data></Cell>
          <Cell><Data ss:Type="String">NIT</Data></Cell>
          <Cell><Data ss:Type="String">DV</Data></Cell>
          <Cell><Data ss:Type="String">CLASE PERSONA</Data></Cell>
          <Cell><Data ss:Type="String">NAJU</Data></Cell>
          <Cell><Data ss:Type="String">GRSE</Data></Cell>
          <Cell><Data ss:Type="String">SERV</Data></Cell>
          <Cell><Data ss:Type="String">NIVEL</Data></Cell>
          <Cell><Data ss:Type="String">CARACTER</Data></Cell>
          <Cell><Data ss:Type="String">AMBULATORIO</Data></Cell>
          <Cell><Data ss:Type="String">HOSPITALARIO</Data></Cell>
          <Cell><Data ss:Type="String">UNIDAD MOVIL</Data></Cell>
          <Cell><Data ss:Type="String">DOMICILIARIO</Data></Cell>
          <Cell><Data ss:Type="String">OTRAS EXTRAMURAL</Data></Cell>
          <Cell><Data ss:Type="String">CENTRO REFERENCIA</Data></Cell>
          <Cell><Data ss:Type="String">INSTITUCION REMISORA</Data></Cell>
          <Cell><Data ss:Type="String">ACTIVO</Data></Cell>
          <Cell><Data ss:Type="String">NUMERO DISTINTIVO</Data></Cell>
          <Cell><Data ss:Type="String">NUMERO SEDE PRINCIPAL</Data></Cell>
          <Cell><Data ss:Type="String">FECHA APERTURA</Data></Cell>
          <Cell><Data ss:Type="String">FECHA CIERRE</Data></Cell>
          <Cell><Data ss:Type="String">EMAIL CONTACTO 1</Data></Cell>
          <Cell><Data ss:Type="String">TELEFONO CONTACTO 1</Data></Cell>
          <Cell><Data ss:Type="String">EMAIL CONTACTO 2</Data></Cell>
          <Cell><Data ss:Type="String">TELEFONO CONTACTO 2</Data></Cell>
          <Cell><Data ss:Type="String">EMAIL CONTACTO 3</Data></Cell>
          <Cell><Data ss:Type="String">TELEFONO CONTACTO 3</Data></Cell>
          <Cell><Data ss:Type="String">EMAIL CONTACTO 4</Data></Cell>
          <Cell><Data ss:Type="String">TELEFONO CONTACTO 4</Data></Cell>
          <Cell><Data ss:Type="String">EMAIL CONTACTO 5</Data></Cell>
          <Cell><Data ss:Type="String">TELEFONO CONTACTO 5</Data></Cell>
          <Cell><Data ss:Type="String">EMAIL CONTACTO 6</Data></Cell>
          <Cell><Data ss:Type="String">TELEFONO CONTACTO 6</Data></Cell>
        </Row>
    FOO
    content.html_safe
  end

  def self.to_xls_row(institucion)
    content = <<-FOO
      <Row>
        <Cell><Data ss:Type="String">#{institucion.codigo}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.numero_sede}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.nombre}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.direccion}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.telefono}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.email}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.nit}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.dv}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.clase_persona}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.naju_nombre}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.grse_nombre}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.serv_nombre}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.nivel}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.caracter}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.ambulatorio}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.hospitalario}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.unidad_movil}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.domiciliario}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.otras_extramural}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.centro_referencia}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.institucion_remisora ? institucion.institucion_remisora.nombre : nil}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.activo}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.numero_distintivo}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.numero_sede_principal}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.fecha_apertura}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.fecha_cierre}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.email_contacto_uno}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.telefono_contacto_uno}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.email_contacto_dos}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.telefono_contacto_dos}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.email_contacto_tres}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.telefono_contacto_tres}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.email_contacto_cuatro}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.telefono_contacto_cuatro}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.email_contacto_cinco}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.telefono_contacto_cinco}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.email_contacto_seis}</Data></Cell>
        <Cell><Data ss:Type="String">#{institucion.telefono_contacto_seis}</Data></Cell>
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
