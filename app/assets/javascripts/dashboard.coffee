jQuery(document).ready ($) ->
  if window.location.pathname == Routes.root_path()

    # get the data
    $.getJSON Routes.totals_invoices_path({format: 'json'}), (data) ->
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
          labels: true
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
