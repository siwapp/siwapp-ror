jQuery(document).ready ($) ->
  $("input[name='default_series'],input[name='default_template']").on("change", () -> $('form.change_default').submit())