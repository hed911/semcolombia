$ ->
  url = location.origin + '/functions/update_departamentos'
  url2 = location.origin + '/functions/update_municipios'
  url3 = location.origin + '/functions/update_cementerios'

  $(document).on 'click', '#countries_select', (evt) ->
    $.ajax url,
      type: 'GET'
      dataType: 'script'
      format: 'js'
      data: {
        country_id: $("#countries_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")

  $(document).on 'click', '#departamentos_select', (evt) ->
    $.ajax url2,
      type: 'GET'
      dataType: 'script'
      format: 'js'
      data: {
        departamento_id: $("#departamentos_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")


  $(document).on 'click', '#municipios_select', (evt) ->
    $.ajax url3,
      type: 'GET'
      dataType: 'script'
      format: 'js'
      data: {
        municipio_id: $("#municipios_select option:selected").val()
      }
      error: (jqXHR, textStatus, errorThrown) ->
        console.log("AJAX Error: #{textStatus}")
      success: (data, textStatus, jqXHR) ->
        console.log("Dynamic country select OK!")