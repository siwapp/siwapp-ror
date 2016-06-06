jQuery(document).ready ($) ->
  if window.location.pathname == Routes.root_path()

    # get the data
    $.getJSON Routes.sums_invoices_path({format: 'json'}), (data)->
      labels = []
      series = []
      $.each data, (key, val)->
        labels.push key
        series.push val
      # display the chart
      new (Chartist.Line)('#db-chart', {
          labels: labels
          series: [series,]
        },
        low: 0
        fullWidth: true
        chartPadding: { right: 50 }
        showArea: true
        lineSmooth: Chartist.Interpolation.simple()
        plugins: [
          Chartist.plugins.tooltip({class: 'ct-tooltip'})
        ]
      )
