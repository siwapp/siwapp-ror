jQuery(document).ready ($) ->
  if window.location.pathname == Routes.recurring_invoices_path()
    # Chart
    chartDisplayed = false
    $('#js-section-info').on 'shown.bs.collapse', ->
      if not chartDisplayed
        chartDisplayed = true
        $.getJSON Routes.chart_data_recurring_invoices_path({format: 'json'}), (data) ->
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

