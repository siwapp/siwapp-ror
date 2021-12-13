jQuery(document).ready ($) ->
  $('#js-copy-address').on 'click', (e) ->
    e.preventDefault()
    shippingAddress = $('[data-address="shipping"]')
    shippingAddress.val($('[data-address="invoice"]').val())
    autosize.update(shippingAddress)

  if window.location.pathname == Routes.invoices_path()
    # Chart
    chartDisplayed = false
    $('#js-section-info').on 'shown.bs.collapse', ->
      if not chartDisplayed
        chartDisplayed = true
        $.getJSON Routes.chart_data_invoices_path({format: 'json'}) + window.location.search, (data) ->
          columns = [['Labels'], ['Total']]

          $.each data, (key, value) ->
            columns[0].push key
            columns[1].push value

          chart = c3.generate
            bindto: '#js-invoices-chart'
            data:
              type: 'area-step'
              x: 'Labels'
              columns: columns
            axis:
              x:
                type: 'timeseries'
                tick:
                  format: '%d %b'
            grid:
              y:
                show: true
            legend:
              show: false
  
  $('.category-select').change ->
    id_string = @id
    id = id_string.split('_')[3]
    $('#invoice_items_attributes_' + id + '_unitary_cost').val @value
    return

