jQuery(document).ready ($) ->
  if window.location.pathname == Routes.root_path()
    # Chart
    $.getJSON Routes.chart_data_invoices_path({format: 'json'}), (data) ->
      columns = [['Labels'], ['Total']]

      $.each data, (key, value) ->
        columns[0].push key
        columns[1].push value

      chart = c3.generate
        bindto: '#js-dashboard-chart'
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
