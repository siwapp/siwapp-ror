jQuery(document).ready ($) ->
  $("input[name='default_series'],input[name='default_template'],input[name='default_tax[]']").on("change", () -> $('form.change_default').submit())